require 'active_record'
require_relative 'basic_model'

module Model
  class HistoryRelation < ActiveRecord::Base
    extend BasicModel
  end
end
