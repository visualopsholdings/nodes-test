require 'mongoid'

class Doc
   include Mongoid::Document
   include Mongoid::Attributes::Dynamic

   field :name, type: String
   field :modifyDate, type: Time
   field :policy, type: String
   field :imports, type: Array
   field :upstream, type: Boolean
  
   def self.upload(filename)
    data_hash = JSON.parse(File.read(filename))
    doc = Doc.create(data_hash)
    doc.modifyDate = DateTime.now
    doc.save
    return doc
  end
  
   def self.uploadWithId(filename, id)
    data_hash = JSON.parse(File.read(filename))
    data_hash[:_id] = id
    doc = Doc.create(data_hash)
    doc.modifyDate = DateTime.now
    doc.save
    return doc
  end
  
end
