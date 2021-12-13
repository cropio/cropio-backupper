require 'active_record'
require_relative 'basic_model'

module Model
  class FuelType < ActiveRecord::Base
    extend BasicModel
  end
end
