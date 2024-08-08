require 'mongoid'

class Info
  include Mongoid::Document
  
  field :type, type: String
  field :text, type: String
  field :date, type: Time
  
end
