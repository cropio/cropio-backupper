require_relative 'app'
require_relative 'logger'
require_relative 'resource_fetcher'
require_relative 'data_integrity_checker'
require_relative 'data_importer'

Dir.glob(App::ROOT + '/lib/models/*', &method(:require))

class Downloader
  include Cropio::Resources

  attr_accessor :processed_model, :from_time, :to_time,
              :processing_history, :logger

  def download_all_data
    ResourceFetcher.resources.sort.each do |model|
      begin
        @processed_model = Object.const_get(model)
        model_class = Object.const_get("Model::#{model}")
        update_processing_status

        data = ResourceFetcher.fetch_data_for_model(model, from_time, to_time, logger)
        ActiveRecord::Base.transaction do
          DataImporter.new(model_class, logger, data).import_data
	        DataIntegrityChecker.new(processed_model, processing_history, logger).check(model_class)
          App::REDIS.set(model_name, to_time)
        end
      rescue Exception => e
        logger.print "Problem with model #{model.to_s}"
        logger.print e.message
      end
    end

    logger.print "All done..."
  end

  def update_processing_status
    @processing_history = true

    @from_time = start_time_for_downloading_data
    @to_time = end_time_for_downloading_data
  end

  def start_time_for_downloading_data
    App::REDIS.get(model_name) || App::START_DOWNLOAD_YEAR
  end

  def end_time_for_downloading_data
    supposed_time = from_time.to_time + App::download_period
    if supposed_time > Time.now
      supposed_time = Time.now
      @processing_history = false
    end

    supposed_time
  end

  def model_name
    processed_model.name.demodulize
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
