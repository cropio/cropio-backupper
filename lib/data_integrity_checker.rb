class DataIntegrityChecker
  MODELS_WITHOUT_CLEANING_IN_LOCAL_DB = %i[Version].freeze

  attr_accessor :processing_history

  def initialize(processed_model, processing_history, logger)
    @processed_model = processed_model
    @logger = logger
    @processing_history = processing_history
  end

  def check(klass)
    remove_deleted_records_in_db(klass)
    check_data_integrity(klass)
  end

  private

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

    @logger.print "#{model_name.ljust(45)} | "\
                  "There is #{ids.count} records that absent in local DB. "\
                  'Trying to recreate them...'

    ids.each_with_index do |id, i|
      rec = @processed_model.find(id)
      next if rec.nil?

      model_class.create_or_update(rec.attributes)
      @logger.print_on_same_line "ReSaving #{i}..."
    end
  end

  private

  def model_name
    @processed_model.name.demodulize
  end

  def cropio_ids
    @cropio_ids ||= @processed_model.ids
  end
end
