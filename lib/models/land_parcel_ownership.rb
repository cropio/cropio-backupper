require 'active_record'
require_relative 'basic_model'

module Model
  class LandParcelOwnership < ActiveRecord::Base
    extend BasicModel
  end
end
