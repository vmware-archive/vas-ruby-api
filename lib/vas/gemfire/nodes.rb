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


module Gemfire
  
  # Used to enumerate GemFire nodes
  class Nodes < Shared::Collection

    # @private
    def initialize(location, client)
      super(location, client, 'nodes', Node)
    end

  end

  # A GemFire node
  class Node < Shared::GroupableNode

    # @return [String] the Node's Java home
    attr_reader :java_home
    
    # @return [AgentNodeInstances] the node's agent instances
    attr_reader :agent_instances
    
    # @return [CacheServerInstances] the node's cache server instances
    attr_reader :cache_server_instances
    
    # @return [LocatorNodeInstances] the node's locator instances
    attr_reader :locator_instances

    # @private
    def initialize(location, client)
      super(location, client, Group)
      @agent_instances_location = Util::LinkUtils.get_link_href(details, 'agent-node-instances')
      @cache_server_instances_location = Util::LinkUtils.get_link_href(details, 'cache-server-node-instances')
      @locator_instances_location = Util::LinkUtils.get_link_href(details, 'locator-node-instances')
    end

    # Reloads the node's details from the server
    # @return [void]
    def reload
      super
      @java_home = details['java-home']
    end

    # @return [AgentNodeInstances] the node's agent instances
    def agent_instances
      @agent_instances ||= AgentNodeInstances.new(@agent_instances_location, client)
    end

    # @return [CacheServerNodeInstances] the node's server instances
    def cache_server_instances
      @cache_server_instances ||= CacheServerNodeInstances.new(@cache_server_instances_location, client)
    end

    # @return [LocatorNodeInstances] the node's locator instances
    def locator_instances
      @locator_instances ||= LocatorNodeInstances.new(@locator_instances_location, client)
    end

    # @return [String] a string representation of the node
    def to_s
      "#<#{self.class} host_names='#{host_names}' ip_addresses='#{ip_addresses}' ipv4_addresses='#{ipv4_addresses}' ipv6_addresses='#{ipv6_addresses}' operating_system='#{operating_system}' architecture='#{architecture}' agent_home='#{agent_home}' java_home='#@java_home' metadata='#{metadata}'>"
    end

  end

end