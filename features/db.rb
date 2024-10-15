
Given(/^there are users:$/) do |users|

   users.hashes.each do |s|
   
      user = FactoryBot.build(:user)
      user.name = s[:name]
      user.admin = s[:admin]
      
      if s[:id] && s[:id].length > 0
         user._id = s[:id]
      end
      
      if s[:fullname] && s[:fullname].length > 0
         user.fullname = s[:fullname]
      end
            
      if s[:active] && s[:active].length > 0
         user.active = s[:active] == "true"
      else
         user.active = true
      end

      if s[:modifyDate] && s[:modifyDate].length > 0
         user.modifyDate = parse_date(s[:modifyDate])
      end

      if s[:upstream] && s[:upstream].length > 0
         user.upstream = s[:upstream] == "true"
      end

      user.save
      
   end
   
end

Given(/^there are policies:$/) do |table|

   table.hashes.each do |s|
      policy = FactoryBot.build(:policy)
      policy.name = s[:name]
      
      if s[:id] && s[:id].length > 0
         policy._id = s[:id]
      end
      
#       if s[:users] && s[:users].length > 0
#          policy.users = []
#          s[:users].split(" ").each do |u|
#             policy.users.push(User.where(name: u).first._id.to_s)
#          end
#       end
      
      access = FactoryBot.build(:access)
      access.name = 'view'
      if s[:viewuser] && s[:viewuser].length > 0
         s[:viewuser].split(" ").each do |u|
            access.users << User.where(name: u).first._id.to_s
         end
      end
      if s[:viewgroup] && s[:viewgroup].length > 0
         s[:viewgroup].split(";").each do |g|
            access.groups << Group.where(name: g).first._id.to_s
         end
      end
      policy.accesses << access
      
      access = FactoryBot.build(:access)
      access.name = 'edit'
      if s[:edituser] && s[:edituser].length > 0
         s[:edituser].split(" ").each do |u|
            access.users << User.where(name: u).first._id.to_s
         end
      end
      if s[:editgroup] && s[:editgroup].length > 0
         s[:editgroup].split(";").each do |g|
            access.groups << Group.where(name: g).first._id.to_s
         end
      end
      policy.accesses << access

      access = FactoryBot.build(:access)
      access.name = 'exec'
      if s[:execuser] && s[:execuser].length > 0
         s[:execuser].split(" ").each do |u|
            access.users << User.where(name: u).first._id.to_s
         end
      end
      if s[:execgroup] && s[:execgroup].length > 0
         s[:execgroup].split(";").each do |g|
            access.groups << Group.where(name: g).first._id.to_s
         end
      end
      policy.accesses << access
      
      policy.save
   end
   
end

Given(/^there are streams:$/) do |table|

   table.hashes.each do |s|
      stream = FactoryBot.build(:stream)
      
      if s[:id] && s[:id].length > 0
         stream._id = s[:id]
      end
      
      if s[:modifyDate] && s[:modifyDate].length > 0
         stream.modifyDate = parse_date(s[:modifyDate])
      end

      stream.name = s[:name]

      if s[:policy] && s[:policy].length > 0
         stream.policy = Policy.where(name: s[:policy]).first._id.to_s
      end
      if s[:streambits] && s[:streambits].length > 0
         stream.streambits = s[:streambits].to_i
      end

      if s[:upstream] && s[:upstream].length > 0
         stream.upstream = s[:upstream] == "true"
      end

      stream.active = true
      stream.save
   end
end


When('there are groups:') do |table|

   table.hashes.each do |s|
      group = FactoryBot.build(:group)
      
      if s[:id] && s[:id].length > 0
         group._id = s[:id]
      end
      
      if s[:modifyDate] && s[:modifyDate].length > 0
         group.modifyDate = parse_date(s[:modifyDate])
      end

      if s[:upstream] && s[:upstream].length > 0
         group.upstream = s[:upstream] == "true"
      end

      group.name = s[:name]
      group.save
   end

end

When('there are users in group {string}:') do |name, table|

   group = Group.where(name: name).first
   table.hashes.each do |s|
      user = User.where(name: s[:name]).first
      member = FactoryBot.build(:group_member)
      member.user = user._id.to_s
      member.roles = []
      if s[:roles] && s[:roles].length > 0
         s[:roles].split(" ").each do |r|
            member.roles.push(r)
         end
      end
      group.group_members << member
   end
   group.save
   
   puts `$NODES_HOME/build/nodesaggregate --coll=group $NODES_HOME/scripts/useringroups.json`

end

When('the security indexes are generated') do

   puts `$NODES_HOME/build/nodesaggregate --coll=policy $NODES_HOME/scripts/groupeditpermissions.json`
   puts `$NODES_HOME/build/nodesaggregate --coll=policy $NODES_HOME/scripts/groupviewpermissions.json`
   puts `$NODES_HOME/build/nodesaggregate --coll=policy $NODES_HOME/scripts/usereditpermissions.json`
   puts `$NODES_HOME/build/nodesaggregate --coll=policy $NODES_HOME/scripts/userviewpermissions.json`

end

When('there are ideas:') do |ideas|

   ideas.hashes.each do |s|
      idea = FactoryBot.build(:idea)
      idea.text = s[:name]
      idea.policy = Policy.where(name: s[:policy]).first._id.to_s
      if s[:by] && s[:by].length > 0
         idea.user = User.where(name: s[:by]).first._id.to_s
      end
      idea.stream = Stream.where(name: s[:stream]).first._id.to_s
      if s[:modifyDate] && s[:modifyDate].length > 0
         idea.modifyDate = parse_date(s[:modifyDate])
      end
      if s[:doc] && s[:doc].length > 0
         idea.doc = Doc.where(name: s[:doc]).first._id.to_s
      else
         idea.doc = ""
      end
      idea.save
   end

end

Given(/^the server has id "([^"]*)"$/) do |id|
   info = FactoryBot.build(:info)
   info.type = 'serverId'
   info.text = id
   info.save
end

Given(/^there is an info$/) do
   info = FactoryBot.build(:info)
   info.type = 'version'
   info.text = '1.0'
   info.save
end

Given("the server has infos:") do |table|
   table.hashes.each do |s|
      info = FactoryBot.build(:info)
      info.type = s[:type]
      info.text = s[:text]
      info.save
   end
end

When('the server has upstream {string}') do |string|
   info = FactoryBot.build(:info)
   info.type = "upstream"
   info.text = string
   info.save
end

When('the server has privateKey {string}') do |string|
   info = FactoryBot.build(:info)
   info.type = "privateKey"
   info.text = string
   info.save
end

When('the server has pubKey {string}') do |string|
   info = FactoryBot.build(:info)
   info.type = "pubKey"
   info.text = string
   info.save
end

When('the server has upstreamPubKey {string}') do |string|
   info = FactoryBot.build(:info)
   info.type = "upstreamPubKey"
   info.text = string
   info.save
end

Given('the server has privateKey in file {string}') do |path|
   info = FactoryBot.build(:info)
   info.type = "privateKey"
   info.text = File.read(path)
   info.save
end

Given('the server has hasInitialSync') do
   info = FactoryBot.build(:info)
   info.type = "hasInitialSync"
   info.text = "true"
   info.save
end

Given('the server has upstreamLastSeen {string}') do |date|
   info = FactoryBot.build(:info)
   info.type = "upstreamLastSeen"
   info.text = parse_date(date)
   info.save
end

Given("there are sites:") do |table|
   table.hashes.each do |s|
      site = FactoryBot.build(:site)
      if s[:headerTitle] && s[:headerTitle].length > 0
         site.headerTitle = s[:headerTitle]
      end
      if s[:streamBgColor] && s[:streamBgColor].length > 0
         site.streamBgColor = s[:streamBgColor]
      end
      site.save
   end
end

Given("eventually the user fullname {string} with salt and hash appears in the DB") do |fullname|
   eventually { expect(User.where(fullname: fullname).first.salt).not_to be_nil }
   # the hash field for a user needs to be queried directly since it conflicts with a method of ruby
   eventually { expect(Mongoid::Clients.default[:users].find(fullname: fullname).first[:hash]).not_to be_nil }
end

Given(/^groups have policies:$/) do |table|
   table.hashes.each do |s|
      group = Group.where(name: s[:name]).first
      group.policy = Policy.where(name: s[:policy]).first._id.to_s
      group.save
   end
end

When('eventually there is a site {string} in the DB') do |title|
   eventually { expect(Site.where(headerTitle: title).length).to eq(1) }
end

Then(/^eventually there is a group "([^"]*)" in the DB$/) do |name|
   eventually { expect(Group.where(name: name).length).to eq(1) }
end

Given('eventually there are {int} groups in the DB') do |count|
   eventually { expect(Group.count).to eq(count.to_i) }
end

When('eventually there are {int} streams in the DB') do |count|
   eventually { expect(Stream.count).to eq(count.to_i) }
end

Then('eventually there is a stream {string} in the DB') do |name|
   eventually { expect(Stream.where(name: name).length).to eq(1) }
end

Given(/^eventually there are (\d+) ideas in the DB$/) do |n|
   eventually { expect(Idea.count).to eq(n.to_i) }
end

When('the server has nodes:') do |table|

   table.hashes.each do |s|
      node = FactoryBot.build(:node)
      node.serverId = s[:id]
      node.pubKey = s[:pubKey]
      if s[:headerTitle] && s[:headerTitle].length > 0
         node.headerTitle = s[:headerTitle]
      end
      if s[:build] && s[:build].length > 0
         node.build = s[:build]
      end
      node.save
   end
   
end

When(/^eventually the group "([^"]*)" with (\d+) member appears in the DB$/) do |group, count|
   eventually { expect(Group.where(name: group).first.group_members.count).to eq(count.to_i) }
end

Given(/^there are media:$/) do |table|
   table.hashes.each do |s|
      media = FactoryBot.build(:media)
      media.name = s[:name]
      if s[:id] && s[:id].length > 0
         media._id =  s[:id]
      end
      if s[:policy] && s[:policy].length > 0
         media.policy =  Policy.where(name: s[:policy]).first._id.to_s
      end
      if s[:modifyDate] && s[:modifyDate].length > 0
         media.modifyDate = parse_date(s[:modifyDate])
      end    
      if s[:upstream] && s[:upstream].length > 0
         media.upstream = s[:upstream] == "true"
      end

      media.save
   end
end

Given(/^there are formats for media "([^"]*)":$/) do |media, table|

   media = Media.where(name: media).first._id.to_s
   
   table.hashes.each do |s|
   
      f = FactoryBot.build(:format)
      f.media = media
      f.name = s[:name]
      f.uuid = s[:uuid]
      
      p = FactoryBot.build(:format_property)
      p.name = "ffmpegVersion"
      p.value = "1.0.0"
      f.format_property << p
      
      p = FactoryBot.build(:format_property)
      p.name = "start"
      p.value = "0.000000"
      f.format_property << p
      
      if s[:md5hash] && s[:md5hash].length > 0
         f.md5hash = s[:md5hash]
      end
      
      if s[:type] == "movie"
         f.mime = "video/mp4"
         
         p = FactoryBot.build(:format_property)
         p.name = "duration"
         p.value = "00:00:25.93"
         f.format_property << p
         
         s = FactoryBot.build(:format_stream)
         s.streamType = "video"
         
         p = FactoryBot.build(:format_property)
         p.name = "encoding"
         p.value = "H.264"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "colorspace"
         p.value = "yuv420p"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "width"
         p.value = "640"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "height"
         p.value = "480"
         s.format_property << p

         p = FactoryBot.build(:format_property)
         p.name = "bitrate"
         p.value = "357 kb/s"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "framerate"
         p.value = "24 fps"
         s.format_property << p
         
         f.format_stream << s
         
         s = FactoryBot.build(:format_stream)
         s.streamType = "audio"
         
         p = FactoryBot.build(:format_property)
         p.name = "encoding"
         p.value = "aac"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "samplerate"
         p.value = "16000 Hz"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "channels"
         p.value = "mono"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "format"
         p.value = "fltp"
         s.format_property << p

         p = FactoryBot.build(:format_property)
         p.name = "bitrate"
         p.value = "334 kb/s"
         s.format_property << p
         
         f.format_stream << s

      elsif s[:type] == "audio"
      
         f.mime = "audio/mp3"
         
         p = FactoryBot.build(:format_property)
         p.name = "duration"
         p.value = "00:00:25.93"
         f.format_property << p
         
         s = FactoryBot.build(:format_stream)
         s.streamType = "audio"
         
         p = FactoryBot.build(:format_property)
         p.name = "encoding"
         p.value = "aac"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "samplerate"
         p.value = "16000 Hz"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "channels"
         p.value = "mono"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "format"
         p.value = "fltp"
         s.format_property << p

         p = FactoryBot.build(:format_property)
         p.name = "bitrate"
         p.value = "334 kb/s"
         s.format_property << p
         
         f.format_stream << s

      else
         f.mime = "image/jpg"
         
         s = FactoryBot.build(:format_stream)
         s.streamType = "video"
         
         p = FactoryBot.build(:format_property)
         p.name = "encoding"
         p.value = "mjpeg"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "colorspace"
         p.value = "yuvj444p"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "width"
         p.value = "1024"
         s.format_property << p
         
         p = FactoryBot.build(:format_property)
         p.name = "height"
         p.value = "768"
         s.format_property << p
         
         f.format_stream << s

      end
      
      f.save
   end
end

When(/^user "([^"]*)" has image "([^"]*)"$/) do |user, image|
   user = User.where(name: user).first
   user.image = Media.where(name: image).first._id.to_s
   user.save
end

When(/^group "([^"]*)" has image "([^"]*)"$/) do |group, image|
   group = Group.where(name: group).first
   group.image = Media.where(name: image).first._id.to_s
   group.save
end

When(/^stream "([^"]*)" has image "([^"]*)"$/) do |name, image|
   stream = Stream.where(name: name).first
   stream.image = Media.where(name: image).first._id.to_s
   stream.save
end

Given(/^there are docs:$/) do |table|
   table.hashes.each do |s|
      if s[:data] && s[:data].length > 0
         if s[:id] && s[:id].length > 0
            doc = Doc.uploadWithId(s[:data], s[:id])
         else
            doc = Doc.upload(s[:data])
         end
      else
         doc = FactoryBot.build(:doc)
         if s[:id] && s[:id].length > 0
            doc._id = s[:id]
         end
      end
      
      if s[:modifyDate] && s[:modifyDate].length > 0
         doc.modifyDate = parse_date(s[:modifyDate])
      end
      
      if s[:upstream] && s[:upstream].length > 0
         doc.upstream = s[:upstream] == "true"
      end

      doc.name = s[:name]

      if s[:policy] && s[:policy].length > 0
         doc.policy = Policy.where(name: s[:policy]).first._id.to_s
      end
      doc.save
   end
end

Given(/^the doc "([^"]*)" imports docs:$/) do |name, table|
   doc = Doc.where(name: name).first
   doc.imports = []
   table.hashes.each do |s|
      doc.imports.push(Doc.where(name: s[:name]).first._id.to_s)
   end
   doc.save
end
