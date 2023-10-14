require 'active_record'
require_relative 'basic_model'

module Model
  class GrowthScale < ActiveRecord::Base
    extend BasicModel
  end
end
