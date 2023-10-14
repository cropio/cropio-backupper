require "cropio"

module ResourceFetcher
  include Cropio::Resources

  DISABLED_MODELS = %i[Version].freeze

  def self.fetch_data_for_model(model, from_time, to_time, logger)
    processed_model = Object.const_get(model)

    logger.print_on_same_line "Downloading #{model} from Cropio... "\
                              "From: #{from_time} To: #{to_time}"

    data = processed_model.changes(from_time.to_s, to_time.to_s)
    logger.print "#{model.to_s.ljust(45)} | Size: "\
                 "#{data.size.to_s.ljust(13)} | "\
                 "From: #{from_time} | To: #{to_time}"
    data
  end

  def self.resources
    @resources ||=
      Cropio::Resources
      .constants
      .select { |c| Cropio::Resources.const_get(c).is_a? Class }

    @resources - DISABLED_MODELS + App::ADDITIONAL_MODELS
  end
end
