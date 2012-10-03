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

  # Used to enumerate, create, and delete server instances.
  class ServerInstances < Shared::MutableCollection

    private

    CREATE_PAYLOAD_KEYS = ['bind-address',
                           'client-bind-address',
                           'client-port',
                           'critical-heap-percentage',
                           'initial-heap',
                           'jvm-options',
                           'max-heap',
                           'run-netserver']

    public

    # @private
    def initialize(location, client)
      super(location, client, "server-group-instances", ServerInstance)
    end

    # Creates a new server instance
    #
    # @param installation [Installation] the installation that the instance will use
    # @param name [String] the name of the instance
    # @param options [Hash] optional configuration for the instance
    #
    # @option options 'bind-address' [String] The property in a node's metadata to use to determine the address that the
    #   server binds to for peer-to-peer communication. If omitted, or if the property does not exist, the server will
    #   use the node's hostname
    # @option options 'client-bind-address' [String] The property in a node's metadata to use to determine the address
    #   that the server binds to for client communication. If omitted, or if the property does not exist, the server
    #   will use the node's hostname. Only takes effect if +run-netserver+ is +true+
    # @option options 'client-port' [Integer] The port that the server listens on for client connections. Only take
    #   effect if +run-netserver+ is +true+
    # @option options 'critical-heap-percentage' [Integer] Critical heap threshold as a percentage of the old generation
    #   heap
    # @option options 'initial-heap' [String] The intial heap size to be used by the server's JVM. If not specified,
    #   the JVM's default is used
    # @option options 'jvm-options' [String[]] The JVM options that are passed to the server's JVM when it is started
    # @option options 'max-heap' [String] The maximum heap size to be used by the server's JVM. If not specified, the
    #   JVM's default is used
    # @option options 'run-netserver' [Boolean] Whether the locator should run a netserver that can service thin
    #   clients. Default is +true+.
    #
    # @return [ServerInstance] the new server instance
    def create(installation, name, options = {})
      payload = { :installation => installation.location, :name => name }

      options.each { |key, value|
        if (CREATE_PAYLOAD_KEYS.include?(key))
          payload[key] = value
        end
      }

      super(payload, 'server-group-instance')
    end

  end

  # A server instance
  class ServerInstance < Shared::Instance

    private

    UPDATE_PAYLOAD_KEYS = ['bind-address',
                           'client-bind-address',
                           'client-port',
                           'critical-heap-percentage',
                           'initial-heap',
                           'jvm-options',
                           'max-heap',
                           'run-netserver']

    public

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
      super(location, client, Group, Installation, ServerLiveConfigurations, ServerPendingConfigurations, ServerNodeInstance, 'server-node-instance')
    end

    # Updates the instance using the supplied +options+.
    #
    # @param options [Hash] optional configuration for the instance
    #
    # @option options 'bind-address' [String] The property in a node's metadata to use to determine the address that the
    #   server binds to for peer-to-peer communication. If omitted or +nil+, the configuration will not be changed. If
    #   set to an empty string the server will use the node's hostname
    # @option options 'client-bind-address' [String] The property in a node's metadata to use to determine the address
    #   that the server binds to for client communication. If omitted or +nil+, the configuration will not be changed.
    #   If set to an empty string the server will bind to localhost
    # @option options 'client-port' [Integer] The port that the server listens on for client connections. If omitted or
    #   +nil+, the configuration will not be changed
    # @option options 'critical-heap-percentage' [Integer] Critical heap threshold as a percentage of the old generation
    #   heap. Valid value are 0-100 inclusive. If omitted or +nil+, the configuration will not be changed
    # @option options 'initial-heap' [String] The intial heap size to be used by the server's JVM. If omitted or +nil+,
    #   the configuration will not be changed. If set to an empty string the JVM's default is used
    # @option options :installation [String] The installation to be used by the instance. If omitted or +nil+, the
    #   configuration will not be changed.
    # @option options 'jvm-options' [String[]] The JVM options that are passed to the server's JVM when it is started.
    #   If omitted or +nil+, the configuration will not be chanaged
    # @option options 'max-heap' [String] The maximum heap size to be used by the server's JVM. If omitted or +nil+, the
    #   configuration will not be changed. If set to an empty string the JVM's default is used
    # @option options 'run-netserver' [Boolean] Whether the server should run a netserver that can service thin
    #   clients. If omitted or +nil+, the configuration will not be changed
    #
    # @return [void]
    def update(options = {})
      payload = {}

      options.each { |key, value|
        if (UPDATE_PAYLOAD_KEYS.include?(key))
          payload[key] = value
        end
      }

      if (options.has_key? :installation)
        payload[:installation] = options[:installation].location
      end

      client.post(location, payload)
      reload
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

    # @return [String] a string representation of the instance
    def to_s
      "#<#{self.class} name='#{name}' bind_address='#@bind_address' client_bind_address='#@client_bind_address' client_port='#@client_port' critical_heap_percentage='#@critical_heap_percentage' initial_heap='#@initial_heap' jvm_options='#@jvm_options' max_heap='#@max_heap' run_netserver='#@run_netserver'>"
    end

  end

end