require 'active_record'
require_relative 'basic_model'

module Model
  class DataSourceGpsLogger < ActiveRecord::Base
    extend BasicModel
  end
end
