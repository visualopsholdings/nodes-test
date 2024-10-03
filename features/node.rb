require 'mongoid'

class Node
   include Mongoid::Document
  
   field :serverId, type: String
   field :pubKey, type: String
   field :headerTitle, type: String
   field :build, type: String
   
end
