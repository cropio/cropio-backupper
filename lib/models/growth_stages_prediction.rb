require 'active_record'
require_relative 'basic_model'

module Model
  class GrowthStagesPrediction < ActiveRecord::Base
    extend BasicModel
  end
end
