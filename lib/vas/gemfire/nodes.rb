#--
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
#++

module Gemfire
  
  # Used to enumerate GemFire nodes
  class Nodes < Shared::Collection

    def initialize(location, client) #:nodoc:
      super(location, client, "nodes", Node)
    end

  end

  # A GemFire node
  class Node < Shared::GroupableNode

    # The Node's Java home
    attr_reader :java_home

    def initialize(location, client) #:nodoc:
      super(location, client, Group)
      @java_home = details["java-home"]
    end

    # The node's agent instances
    def agent_instances
      @instances = AgentNodeInstances.new(Util::LinkUtils.get_link_href(details, "agent-node-instances"), client)
    end

    # The node's cache server instances
    def cache_server_instances
      @instances = CacheServerNodeInstances.new(Util::LinkUtils.get_link_href(details, "cache-server-node-instances"), client)
    end

    # The node's locator instances
    def locator_instances
      @instances = LocatorNodeInstances.new(Util::LinkUtils.get_link_href(details, "locator-node-instances"), client)
    end
    
    def to_s #:nodoc:
      "#<#{self.class} host_names='#{host_names}' ip_addresses='#{ip_addresses}' operating_system='#{operating_system}' architecture='#{architecture}' agent_home='#{agent_home}' java_home='#{java_home}' metadata='#{metadata}'>"
    end

  end

end