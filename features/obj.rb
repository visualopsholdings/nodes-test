require 'mongoid'

class Obj
   include Mongoid::Document
  
   field :basedoc, type: String
   field :policy, type: String
   field :text, type: String
   field :user, type: String
   field :modifyDate, type: Time
   field :coll, type: String
   field :uuid, type: String
   field :binStatus, type: Integer
   
end
