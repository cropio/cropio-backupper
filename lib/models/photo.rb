require 'active_record'
require_relative 'basic_model'

module Model
  class Photo < ActiveRecord::Base
    extend BasicModel
  end
end
