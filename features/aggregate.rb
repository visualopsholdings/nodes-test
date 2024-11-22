
def aggregate(script, coll)

   # honour env variables for DB name and where NODES is.
   dbname=ENV['MONGO_PORT_27017_DB']
   home=  ENV['NODES_HOME']
   
   # same defaults as inside local.sh
   if !dbname
      dbname ='dev'
   end
   
   cmd = home + "/build/nodesaggregate --coll=" + coll + " --dbName=" + dbname + " " + home + "/scripts/" + script
   puts `#{cmd}`

end

