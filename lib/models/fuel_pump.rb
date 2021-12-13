require 'active_record'
require_relative 'basic_model'

module Model
  class FuelPump < ActiveRecord::Base
    extend BasicModel
  end
end
