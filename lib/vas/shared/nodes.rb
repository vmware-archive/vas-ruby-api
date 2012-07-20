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

module Shared
  
  # An enumeration of Node s
  class Nodes < Shared::Collection

    def initialize(location, client) #:nodoc:
      super(location, client, "nodes")
    end

  end

  # A node
  class Node < Shared::Resource
    
    # The location of the vFabric Administration agent
    attr_reader :agent_home
    
    # The architecture of the node's operating system
    attr_reader :architecture
    
    # The node's host names
    attr_reader :host_names
    
    # The node's IP addresses
    attr_reader :ip_addresses
    
    # The node's metadata
    attr_reader :metadata
    
    # The node's operating system
    attr_reader :operating_system

    def initialize(location, client)  #:nodoc:
      super(location, client)
      
      @agent_home = details["agent-home"]
      @architecture = details["architecture"]
      @host_names = details["host-names"]
      @ip_addresses = details["ip-addresses"]
      @metadata = details["metadata"]
      @operating_system = details["operating-system"]
    end

  end

end