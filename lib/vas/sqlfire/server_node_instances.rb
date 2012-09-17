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

  # Used to enumerate server instances on an individual node
  class ServerNodeInstances < Shared::NodeInstances

    # @private
    def initialize(location, client)
      super(location, client, "server-node-instances", ServerNodeInstance)
    end

  end

  # A server node instance
  class ServerNodeInstance < Shared::NodeInstance

    # @private
    def initialize(location, client)
      super(location, client, Node, ServerLogs, ServerInstance, 'server-group-instance')
    end

    # @return [String] the property in a node's metadata used to determine the address that the server binds to for
    #   peer-to-peer communication. If +nil+, the server uses the node's hostname
    def bind_address
      client.get(location)['bind-address']
    end

    # @return [String] the property in a node's metadata used to determine the address that the server binds to for
    #   client communication. If +nil+, the server uses localhost. Only takes effect if +run_netserver+ is +true+
    def client_bind_address
      client.get(location)['client-bind-address']
    end

    # @return [Integer] the port that the server listens on for client connections. Only takes effect if +run_netserver+
    #   is +true+
    def client_port
      client.get(location)['client-port']
    end

    # @return [Integer] critical heap percentage as a percentage of the old generation heap. +nil+ if the server uses
    #   the default
    def critical_heap_percentage
      client.get(location)['critical-heap-percentage']
    end

    # @return [String] The initial heap size of the server's JVM. +nil+ if the default is used
    def initial_heap
      client.get(location)['initial-heap']
    end

    # @return [String[]] The JVM options that are passed to the server's JVM when it is started
    def jvm_options
      client.get(location)['jvm-options']
    end

    # @return [String] The max heap size of the server's JVM. +nil+ if the default is used
    def max_heap
      client.get(location)['max-heap']
    end

    # @return [Boolean] +true+ if the server runs a netserver that can service thin clients, otherwise +false+
    def run_netserver
      client.get(location)['run-netserver']
    end

  end

end