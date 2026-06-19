require 'active_record'
require_relative 'basic_model'

module Model
  class MachineWorkPlan < ActiveRecord::Base
    extend BasicModel
  end
end
