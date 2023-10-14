class DataImporter

  attr_reader :model_class, :logger, :data

  def initialize(model_class, logger, data)
    @model_class = model_class
    @logger = logger
    @data = data
  end

  def import_data
    needed_attributes = model_class.new.attributes
    models_records_to_import = []

    data.each_with_index do |rec, i|
      selected_attr = rec.attributes.select { |k, _v| needed_attributes.include?(k) }
      models_records_to_import << selected_attr
      logger.print_on_same_line "Creating #{i}..."
    end

    logger.print_on_same_line "Importing data to database..."
    i = 1
    models_records_to_import.each_slice(1000) do |batch|
      model_class.upsert_all(batch, unique_by: :id)
      logger.print_on_same_line "batch #{i}"
      i += 1
    end
  end
end
