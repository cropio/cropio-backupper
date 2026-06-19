require 'active_record'
require_relative 'basic_model'

module Model
  class WeatherItem < ActiveRecord::Base
    extend BasicModel
  end
end
