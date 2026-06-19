require 'active_record'
require_relative 'basic_model'

module Model
  class ScoutReportMeasurementValueType < ActiveRecord::Base
    extend BasicModel
  end
end
