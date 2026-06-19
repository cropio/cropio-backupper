require 'active_record'
require_relative 'basic_model'

module Model
  class WhRelatedDocumentAssignment < ActiveRecord::Base
    extend BasicModel
  end
end
