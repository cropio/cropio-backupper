require 'active_record'
require_relative 'basic_model'

module Model
  class MachineWorkPlanRow < ActiveRecord::Base
    extend BasicModel
  end
end
