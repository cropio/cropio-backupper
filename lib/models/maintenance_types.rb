require 'active_record'
require_relative 'basic_model'

module Model
  class MaintenanceType < ActiveRecord::Base
    extend BasicModel
  end
end
