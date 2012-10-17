#!/usr/bin/env ruby

# vFabric Administration Server Ruby API
# Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


require 'vas'
require 'optparse'

options = {
  :host => "localhost",
  :port => 8443,
  :username => 'admin',
  :password => 'vmware',
  :context_path => '/example'
}

optionParser = OptionParser.new { |opts|
  opts.banner = "Usage: web_application.rb <installation-image.zip> <installation-image-version> <web-application.war> <web-application-version> [options]"
  opts.on("--host <host>", "The vFabric Administration Server host. Defaults to localhost.") { |host|
    options[:host] = host
  }
  opts.on("--port <port>", "The vFabric Administration Server port. Defaults to 8443.") { |port|
    options[:port] = port
  }
  opts.on("--username <username>", "The username to use to connect to the server. Defaults to admin.") { |username|
    options[:username] = username    
  }
  opts.on("--password <password>", "The password to use to connect to the server. Defaults to vmware.") { |password|
    options[:password] = password
  }
  opts.on("--context-path <context-path>", "The context path to deploy the web application to. Defaults to /example.") { |context_path|
    options[:context_path] = context_path
  }
  opts.on_tail("-h", "--help", "Show this usage information") {
    puts optionParser
    exit
  }
}
  
begin
  args = optionParser.parse!
  if (args.size != 4) then
    puts optionParser
    exit 1
  end
rescue OptionParser::MissingArgument, OptionParser::InvalidOption
  puts optionParser
  exit 1
end

installation_image_path = args[0]
installation_image_version = args[1]

revision_image_path = args[2]
revision_image_version = args[3]

tc_server = VFabricAdministrationServer.new(options).tc_server

print 'Creating installation image... '
installation_image = tc_server.installation_images.create(installation_image_path, installation_image_version)
puts 'done'

print 'Creating revision image... '
revision_image = tc_server.revision_images.create(revision_image_path, 'example', revision_image_version)
puts 'done'

print 'Creating group... '
group = tc_server.groups.create('example', tc_server.nodes)
puts 'done'

print 'Creating installation... '
installation = group.installations.create(installation_image)
puts 'done'

print 'Creating instance that will listen on 8080... '
instance = group.instances.create(installation, 'example', { :properties => {'base.jmx.port' => 6970}})
puts 'done'

print "Creating application at #{options[:context_path]}... "
application = instance.applications.create('Example', options[:context_path], 'Catalina', 'localhost')
puts 'done'

print 'Deploying revision... '
revision = application.revisions.create(revision_image)
puts 'done'

print 'Starting instance... '
instance.start
puts 'done'

puts 'Press enter to cleanup'

$stdin.gets

print 'Stopping instance... '
instance.stop
puts 'done'

print 'Deleting group... '
group.delete
puts 'done'

print 'Deleting revision image... '
revision_image.delete
puts 'done'

print 'Deleting installation image... '
installation_image.delete
puts 'done'