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


module Sqlfire

  # Used to enumerate locator instances on an individual node
  class LocatorNodeInstances < Shared::NodeInstances

    # @private
    def initialize(location, client)
      super(location, client, 'locator-node-instances', LocatorNodeInstance)
    end

  end

  # A locator node instance
  class LocatorNodeInstance < Shared::NodeInstance

    # @return [String] the property in a node's metadata used to determine the address that the locator binds to for
    #   peer-to-peer communication. If +nil+, the locator uses the value derived from +peer_discovery_address+
    attr_reader :bind_address

    # @return [String] the property in a node's metadata used to determine the address that the locator binds to for
    #   client communication. If +nil+, the locator uses the node's hostname. Only takes effect if +run_netserver+ is
    #   +true+
    attr_reader :client_bind_address

    # @return [Integer] The port that the locator listens on for client connections. Only takes effect if
    # +run_netserver+ is +true+
    attr_reader :client_port

    # @return [String] The initial heap size of the locator's JVM. +nil+ if the default is used
    attr_reader :initial_heap

    # @return [String[]] The JVM options that are passed to the locator's JVM when it is started
    attr_reader :jvm_options

    # @return [String] The max heap size of the locator's JVM. +nil+ if the default is used
    attr_reader :max_heap

    # @return [String] the property in a node's metadata used to determine the address that the locator binds to for
    #   peer-discovery communication. If +nil+, the locator uses +0.0.0.0+
    attr_reader :peer_discovery_address


    # @return [Integer] The port that the locator listens of for peer-discovery connections
    attr_reader :peer_discovery_port

    # @return [Boolean] +true+ if the locator runs a netserver that can service thin clients, otherwise +false+
    attr_reader :run_netserver

    # @private
    def initialize(location, client)
      super(location, client, Node, LocatorLogs, LocatorInstance, 'locator-group-instance',
            LocatorNodeLiveConfigurations)
    end

    def reload
      super
      @bind_address = details['bind-address']
      @client_bind_address = details['client-bind-address']
      @client_port = details['client-port']
      @initial_heap = details['initial-heap']
      @jvm_options = details['jvm-options']
      @max_heap = details['max-heap']
      @peer_discovery_address = details['peer-discovery-address']
      @peer_discovery_port = details['peer-discovery-port']
      @run_netserver = details['run-netserver']
    end

    # @return [String] a string representation of the instance
    def to_s
      "#<#{self.class} name='#{name}' bind_address='#@bind_address' client_bind_address='#@client_bind_address' client_port='#@client_port' initial_heap='#@initial_heap' jvm_options='#@jvm_options' max_heap='#@max_heap' peer_discovery_address='#@peer_discovery_address' peer_discovery_port='#@peer_discovery_port' run_netserver='#@run_netserver'>"
    end

  end

end