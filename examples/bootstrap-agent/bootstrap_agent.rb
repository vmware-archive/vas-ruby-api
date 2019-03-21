#!/usr/bin/env ruby

# vFabric Administration Server Ruby API
# Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
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
  :location => Dir.pwd
}

optionParser = OptionParser.new { |opts|
  opts.banner = "Usage: bootstrap_agent.rb [options]"
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
  opts.on("--location <location>", "The location to install the vFabric Administration Agent. Defaults to the current working directory.") { |location|
    options[:location] = location
  }
  opts.on_tail("-h", "--help", "Show this usage information") {
    puts optionParser
    exit
  }
}
  
begin
  !optionParser.parse!
rescue OptionParser::MissingArgument, OptionParser::InvalidOption
  puts optionParser
  exit 1
end
  
agent_root = VFabricAdministrationServer.new(options).vfabric.agent_image.extract_to(options[:location])
`#{agent_root}/bin/administration-agent.sh start`