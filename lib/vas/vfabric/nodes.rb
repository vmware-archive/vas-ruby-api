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


module VFabric
  
  # Used to enumerate VFabric nodes
  class Nodes < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, 'nodes', Node)
    end

  end

  # Deletes the node
  #
  # @param node [Node] the node to delete
  #
  # @return [void]
  def delete(node)
    client.delete(node.location)
  end

  # A VFabric node
  class Node < Shared::Node
  
    # @private
    def initialize(location, client)
      super(location, client)
    end
    
    # @return [String] a string representation of the node
    def to_s
      "#<#{self.class} host_names='#{host_names}' ip_addresses='#{ip_addresses}' ipv4_addresses='#{ipv4_addresses}' ipv6_addresses='#{ipv6_addresses}' operating_system='#{operating_system}' architecture='#{architecture}' agent_home='#{agent_home}' metadata='#{metadata}'>"
    end

  end

end