require 'active_record'
require_relative 'basic_model'

module Model
  class AdditionalInventoryUnitAssignment < ActiveRecord::Base
    extend BasicModel
  end
end
