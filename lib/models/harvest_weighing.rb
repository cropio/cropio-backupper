require 'active_record'
require_relative 'basic_model'

module Model
  class HarvestWeighing < ActiveRecord::Base
    extend BasicModel
  end
end
