require 'mongoid'

class FormatStream
   include Mongoid::Document

   embedded_in :format
  
   field :streamType, type: String

   embeds_many :format_property, store_as: "properties"

end
