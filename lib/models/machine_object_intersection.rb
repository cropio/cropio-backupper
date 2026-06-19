require 'active_record'
require_relative 'basic_model'

module Model
  class MachineObjectIntersection < ActiveRecord::Base
    extend BasicModel
  end
end
