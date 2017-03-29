require 'active_support'
require 'active_support/core_ext'
require 'cropio'
require_relative '../lib/app'
Dir.glob(App::ROOT + '/lib/models/*', &method(:require))

module Downloader
  include Cropio::Resources

  module_function

  def download_all_data
    resources = Cropio::Resources.constants.select {|c| Cropio::Resources.const_get(c).is_a? Class}
    resources.each do |model|
      from_time = App::REDIS.get(model.to_s) || App::START_DOWNLOAD_YEAR
      to_time = end_time_for_downloading_data(from_time)
      data_from_api = Object.const_get(model).changes(from_time, to_time.to_s)
      puts "#{DateTime.now.utc.to_s} | #{model.to_s.ljust(35)} | Size: #{data_from_api.size.to_s.ljust(13)} | From: #{from_time} | To: #{to_time}"
      model_class = Object.const_get("Model::#{model}")
      ActiveRecord::Base.transaction do
        data_from_api.each do |rec|
          model_class.create_or_update(rec.attributes)
        end
        App::REDIS.set(model.to_s, to_time)
      end
    end
  end

  def end_time_for_downloading_data(from_time)
    supposed_time = from_time.to_time.utc + 1.year
    return Time.now.utc if supposed_time > Time.now.utc
    supposed_time
  end

  def download_data
    download_all_data
  rescue Exception => e
    puts e
    exit(1)
  end
end
