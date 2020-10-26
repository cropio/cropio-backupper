require 'active_support'
require 'active_support/core_ext'
require 'cropio'
require_relative '../lib/app'
require_relative '../lib/logger'
Dir.glob(App::ROOT + '/lib/models/*', &method(:require))

class Downloader
  include Cropio::Resources

  attr_reader :logger, :processed_model, :cropio_ids, :from_time, :to_time,
              :processing_history

  MODELS_WITHOUT_CLEANING_IN_LOCAL_DB = %i[Version].freeze
  DISABLED_MODELS = %i[SatelliteImage Version].freeze

  def download_all_data
    resources.sort.each do |model|
      begin
        @processed_model = Object.const_get(model)
        reset_processing_status

        logger.print_on_same_line "Downloading #{model} from Cropio... "\
                                  "From: #{from_time} To: #{to_time}"

        data_from_api = @processed_model.changes(from_time.to_s, to_time.to_s)
        logger.print "#{model_name.to_s.ljust(45)} | Size: "\
                      "#{data_from_api.size.to_s.ljust(13)} | "\
                      "From: #{from_time} | To: #{to_time}"

        model_class = Object.const_get("Model::#{model}")

        ActiveRecord::Base.transaction do
          data_from_api.each_with_index do |rec, i|
            model_class.create_or_update(rec.attributes)
            logger.print_on_same_line "Saving #{i}..."
          end

          remove_deleted_records_in_db(model_class)
          App::REDIS.set(model_name.to_s, to_time)

          check_data_integrity(model_class)
        end
      rescue Exception => e
        logger.print "Problem with model #{model.to_s}"
        logger.print e.message
      end
    end
  end

  def resources
    resources =
      Cropio::Resources
      .constants
      .select { |c| Cropio::Resources.const_get(c).is_a? Class }

    resources - DISABLED_MODELS + App::ADDITIONAL_MODELS
  end

  def remove_deleted_records_in_db(model_class)
    return if MODELS_WITHOUT_CLEANING_IN_LOCAL_DB.include?(model_name.to_sym)

    db_ids = model_class.all.pluck(:id)
    ids_to_remove = db_ids - cropio_ids
    return if ids_to_remove.empty?

    model_class.where(id: ids_to_remove).delete_all
  end

  def check_data_integrity(model_class)
    return if processing_history

    db_ids = model_class.all.pluck(:id)
    ids = cropio_ids - db_ids
    return if ids.empty?

    logger.print "#{model_name.to_s.ljust(45)} | "\
                      "There is #{ids.count} records that absent in local DB. "\
                      'Trying to recreate them...'

    ids.each_with_index do |id, i|
      rec = @processed_model.find(id)
      next if rec.nil?

      model_class.create_or_update(rec.attributes)
      logger.print_on_same_line "ReSaving #{i}..."
    end
  end

  def end_time_for_downloading_data
    supposed_time = from_time.to_time + App::download_period
    if supposed_time > Time.now
      supposed_time = Time.now
      @processing_history = false
    end

    supposed_time
  end

  def reset_processing_status
    @processing_history = true
    @cropio_ids = nil

    @from_time = start_time_for_downloading_data
    @to_time = end_time_for_downloading_data
  end

  def start_time_for_downloading_data
    App::REDIS.get(model_name) || App::START_DOWNLOAD_YEAR
  end

  def model_name
    @processed_model.name.demodulize
  end

  def cropio_ids
    @cropio_ids ||= @processed_model.ids
  end

  def logger
    @logger ||= Log.new
  end

  def download_data
    download_all_data
  rescue Exception => e
    logger.print e
    exit(1)
  end
end
