require 'active_record'
require_relative 'basic_model'

module Model
  class AdditionalObject < ActiveRecord::Base
    extend BasicModel
  end
end
