
def aggregate(script)

   home = ENV['NODES_HOME']
   dbname=ENV['MONGO_PORT_27017_DB']
   
   if !dbname
      dbname ='dev'
   end
   
   cmd = home + "/build/nodesaggregate --coll=group --dbName=" + dbname + " " + home + "/scripts/" + script
   puts `#{cmd}`

end

