require 'mongoid'

class FormatProperty
   include Mongoid::Document
  
   field :name, type: String
   field :value, type: String
   
end
