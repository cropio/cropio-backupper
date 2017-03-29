require 'active_record'
require_relative 'basic_model'

module Model
  class GroupFolder < ActiveRecord::Base
    extend BasicModel
  end
end
