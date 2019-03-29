require 'active_record'
require_relative 'basic_model'

module Model
  class SparePart < ActiveRecord::Base
    extend BasicModel
  end
end
