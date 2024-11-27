require 'mongoid'

class Collection
   include Mongoid::Document

   field :name, type: String
   field :modifyDate, type: Time
   field :policy, type: String
   field :active, type: Boolean
   field :upstream, type: Boolean
   field :image, type: String

end
