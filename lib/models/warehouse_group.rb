require 'active_record'
require_relative 'basic_model'

module Model
  class WarehouseGroup < ActiveRecord::Base
    extend BasicModel
  end
end
