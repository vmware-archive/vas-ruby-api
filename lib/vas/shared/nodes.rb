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

  # @abstract A node, i.e. a machine with the vFabric Administration agent installed on it
  class Node < Shared::Resource
    
    # @return [String] the location of the vFabric Administration agent
    attr_reader :agent_home
    
    # @return [String] the architecture of the node's operating system
    attr_reader :architecture
    
    # @return [String] the node's host names
    attr_reader :host_names
    
    # @return [String[]] the node's IP addresses
    attr_reader :ip_addresses

    # @return [String[], nil] the node's IPv4 addresses. +nil+ if the server is not version 1.1.0 or later
    attr_reader :ipv4_addresses

    # @return [String[], nil] the node's IPv6 addresses. +nil+ if the server is not version 1.1.0 or later
    attr_reader :ipv6_addresses
    
    # @return [String] the node's operating system
    attr_reader :operating_system

    # @private
    def initialize(location, client)
      super(location, client)
      
      @agent_home = details['agent-home']
      @architecture = details['architecture']
      @host_names = details['host-names']
      @ip_addresses = details['ip-addresses']
      @ipv4_addresses = details['ipv4-addresses']
      @ipv6_addresses = details['ipv6-addresses']
      @metadata = details['metadata']
      @operating_system = details['operating-system']
    end

    # Updates the node's metadata
    def update(metadata)
      client.post(location, {:metadata => metadata})
    end

    # @return [Hash] the node's metadata
    def metadata
      client.get(location)['metadata']
    end

  end

  # @abstract A node that can be grouped
  class GroupableNode < Node
    
    # @private
    def initialize(location, client, group_class)
      super(location, client)
      @group_class = group_class
    end

    # @return [Group[]] the groups that contain this node
    def groups
      groups = []
      Util::LinkUtils.get_link_hrefs(client.get(location), 'group').each {
          |group_location| groups << @group_class.new(group_location, client)}
      groups
    end
  end

end