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


module Sqlfire

  # Used to enumerate locator instances on an individual node
  class LocatorNodeInstances < Shared::NodeInstances

    # @private
    def initialize(location, client)
      super(location, client, "locator-node-instances", LocatorNodeInstance)
    end

  end

  # A locator node instance
  class LocatorNodeInstance < Shared::NodeInstance

    # @private
    def initialize(location, client) #:nodoc:
      super(location, client, Node, LocatorLogs, LocatorInstance, 'locator-group-instance')
    end

    # @return [String] the property in a node's metadata used to determine the address that the locator binds to for
    #   peer-to-peer communication. If +nil+, the locator uses the value derived from +peer_discovery_address+
    def bind_address
      client.get(location)['bind-address']
    end

    # @return [String] the property in a node's metadata used to determine the address that the locator binds to for
    #   client communication. If +nil+, the locator uses the node's hostname. Only takes effect if +run_netserver+ is
    #   +true+
    def client_bind_address
      client.get(location)['client-bind-address']
    end

    # @return [Integer] The port that the locator listens on for client connections. Only takes effect if
    # +run_netserver+ is +true+
    def client_port
      client.get(location)['client-port']
    end

    # @return [String] The initial heap size of the locator's JVM. +nil+ if the default is used
    def initial_heap
      client.get(location)['initial-heap']
    end

    # @return [String[]] The JVM options that are passed to the locator's JVM when it is started
    def jvm_options
      client.get(location)['jvm-options']
    end

    # @return [String] The max heap size of the locator's JVM. +nil+ if the default is used
    def max_heap
      client.get(location)['max-heap']
    end

    # @return [String] the property in a node's metadata used to determine the address that the locator binds to for
    #   peer-discovery communication. If +nil+, the locator uses +0.0.0.0+
    def peer_discovery_address
      client.get(location)['peer-discovery-address']
    end

    # @return [Integer] The port that the locator listens of for peer-discovery connections
    def peer_discovery_port
      client.get(location)['peer-discovery-port']
    end

    # @return [Boolean] +true+ if the locator runs a netserver that can service thin clients, otherwise +false+
    def run_netserver
      client.get(location)['run-netserver']
    end


  end

end