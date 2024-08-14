require 'mongoid'

class Site
   include Mongoid::Document

   field :modifyDate, type: Time
   field :headerTitle, type: String
   field :streamBgColor, type: String

end
