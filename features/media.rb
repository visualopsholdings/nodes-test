require 'mongoid'

class Media
   include Mongoid::Document
  
   field :name, type: String
   field :modifyDate, type: Time
   field :policy, type: String
   field :upstream, type: Boolean
   field :uuid, type: String
   
end
