require 'active_record'
require_relative 'basic_model'

module Model
  class LeafTest < ActiveRecord::Base
    self.table_name = 'soil_tests'
    extend BasicModel
  end
end
