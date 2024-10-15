require 'mongoid'

class Format
   include Mongoid::Document
  
   field :media, type: String
   field :name, type: String
   field :modifyDate, type: Time
   field :mime, type: String
   field :uuid, type: String
   field :md5hash, type: String

   embeds_many :format_property, store_as: "properties"
   embeds_many :format_stream, store_as: "streams"
    
end
