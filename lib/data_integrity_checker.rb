class DataIntegrityChecker
  MODELS_WITHOUT_CLEANING_IN_LOCAL_DB = %i[Version].freeze

  attr_accessor :processing_history

  def initialize(processed_model, processing_history, logger, retention_start = nil)
    @processed_model = processed_model
    @logger = logger
    @processing_history = processing_history
    @retention_start = retention_start
  end

  def check(klass)
    return if processing_history

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
    db_ids = model_class.all.pluck(:id)
    ids = cropio_window_ids - db_ids
    return if ids.empty?

    # Some /ids endpoints ignore updated_at_gt and return the full all-time set
    # (windowed size == full size). The "missing" records are then dominated by
    # pre-retention history we intentionally don't keep — backfilling it violates
    # retention and is very slow. Skip: the changes feed is the source of truth
    # for the retention window.
    if @retention_start && cropio_window_ids.size == cropio_ids.size
      @logger.print "#{model_name.ljust(45)} | /ids ignores updated_at_gt — "\
                    "skipping backfill of #{ids.count} pre-retention records"
      return
    end

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

  def model_name
    @processed_model.name.demodulize
  end

  # Full id set on Cropio — used only to detect records deleted upstream so they
  # can be removed locally. This is a single cheap request.
  def cropio_ids
    @cropio_ids ||= @processed_model.ids
  end

  # Ids whose records were updated within the retention window
  # (updated_at > START_DOWNLOAD_YEAR) — the set the local DB is expected to
  # mirror. Used for backfilling genuinely missing records instead of dragging
  # back the entire pre-retention history one find(id) at a time.
  # Falls back to the full set when no retention floor is given.
  def cropio_window_ids
    return cropio_ids if @retention_start.nil?

    @cropio_window_ids ||= Cropio::Connection::Proxy
                           .get(@processed_model.resources_name,
                                resource_method: :ids,
                                updated_at_gt: @retention_start.to_s)
                           .fetch('data', [])
  end
end
