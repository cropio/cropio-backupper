require 'active_record'
require_relative 'basic_model'

module Model
  class PersonalIdentifier < ActiveRecord::Base
    extend BasicModel
  end
end
