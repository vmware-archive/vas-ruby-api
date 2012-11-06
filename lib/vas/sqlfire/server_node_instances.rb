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
      super(location, client, 'server-node-instances', ServerNodeInstance)
    end

  end

  # A server node instance
  class ServerNodeInstance < Shared::NodeInstance

    # @return [String] the property in a node's metadata used to determine the address that the server binds to for
    #   peer-to-peer communication. If +nil+, the server uses the node's hostname
    attr_reader :bind_address

    # @return [String] the property in a node's metadata used to determine the address that the server binds to for
    #   client communication. If +nil+, the server uses localhost. Only takes effect if +run_netserver+ is +true+
    attr_reader :client_bind_address

    # @return [Integer] the port that the server listens on for client connections. Only takes effect if +run_netserver+
    #   is +true+
    attr_reader :client_port

    # @return [Integer] critical heap percentage as a percentage of the old generation heap. +nil+ if the server uses
    #   the default
    attr_reader :critical_heap_percentage

    # @return [String] The initial heap size of the server's JVM. +nil+ if the default is used
    attr_reader :initial_heap

    # @return [String[]] The JVM options that are passed to the server's JVM when it is started
    attr_reader :jvm_options

    # @return [String] The max heap size of the server's JVM. +nil+ if the default is used
    attr_reader :max_heap

    # @return [Boolean] +true+ if the server runs a netserver that can service thin clients, otherwise +false+
    attr_reader :run_netserver

    # @private
    def initialize(location, client)
      super(location, client, Node, ServerLogs, ServerInstance, 'server-group-instance', ServerNodeLiveConfigurations)
    end

    # Reloads the instance's details from the server
    # @return [void]
    def reload
      super
      @bind_address = details['bind-address']
      @client_bind_address = details['client-bind-address']
      @client_port = details['client-port']
      @critical_heap_percentage = details['critical-heap-percentage']
      @initial_heap = details['initial-heap']
      @jvm_options = details['jvm-options']
      @max_heap = details['max-heap']
      @run_netserver = details['run-netserver']
    end

    # Starts the server node instance, optionally triggering a rebalance
    #
    # @param rebalance [Boolean] +true+ if the start should trigger a rebalance, +false+ if it
    #   should not
    #
    # @return [void]
    def start(rebalance = false)
      client.post(@state_location, { :status => 'STARTED', :rebalance => rebalance })
    end

    # @return [String] a string representation of the instance
    def to_s
      "#<#{self.class} name='#{name}' bind_address='#@bind_address' client_bind_address='#@client_bind_address' client_port='#@client_port' critical_heap_percentage='#@critical_heap_percentage' initial_heap='#@initial_heap' jvm_options='#@jvm_options' max_heap='#@max_heap' run_netserver='#@run_netserver'>"
    end

  end

end