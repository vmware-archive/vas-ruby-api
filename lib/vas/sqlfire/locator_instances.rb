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

  # Used to enumerate, create, and delete locator instances.
  class LocatorInstances < Shared::MutableCollection

    private

    CREATE_PAYLOAD_KEYS = ['bind-address',
                           'client-bind-address',
                           'client-port',
                           'initial-heap',
                           'jvm-options',
                           'max-heap',
                           'peer-discovery-address',
                           'peer-discovery-port',
                           'run-netserver']

    public

    # @private
    def initialize(location, client)
      super(location, client, 'locator-group-instances', LocatorInstance)
    end

    # Creates a new locator instance
    #
    # @param installation [Installation] the installation that the instance will use
    # @param name [String] the name of the instance
    # @param options [Hash] optional configuration for the instance
    #
    # @option options 'bind-address' [String] The property in a node's metadata to use to determine the address that the
    #   locator binds to for peer-to-peer communication. If omitted, or if the property does not exist, the locator will
    #   use the value derived from +peer-discovery-address+
    # @option options 'client-bind-address' [String] The property in a node's metadata to use to determine the address
    #   that the locator binds to for client communication. If omitted, or if the property does not exist, the locator
    #   will use the node's hostname. Only takes effect if +run-netserver+ is +true+
    # @option options 'client-port' [Integer] The port that the locator listens on for client connections. Only take
    #   effect if +run-netserver+ is +true+
    # @option options 'initial-heap' [String] The intial heap size to be used by the locator's JVM. If not specified,
    #   the JVM's default is used
    # @option options 'jvm-options' [String[]] The JVM options that are passed to the locator's JVM when it is started
    # @option options 'max-heap' [String] The maximum heap size to be used by the locator's JVM. If not specified, the
    #   JVM's default is used
    # @option options 'peer-discovery-address' [String] The property in a node's metadata to use to determine the
    #   address that the locator binds to for peer-discovery communication. If omitted, or if the property does not
    #   exist, the locator will use +0.0.0.0+
    # @option options 'peer-discovery-port' [Integer] The port that the locator listens on for peer-discovery
    #   connections. If omitted, the locator will listen on the default port (10334)
    # @option options 'run-netserver' [Boolean] Whether the locator should run a netserver that can service thin
    #   clients. Default is +true+.
    #
    # @return [LocatorInstance] the new instance
    def create(installation, name, options = {})

      payload = {:installation => installation.location,
                 :name => name}

      options.each { |key, value|
        if (CREATE_PAYLOAD_KEYS.include?(key))
          payload[key] = value
        end
      }

      super(payload, 'locator-group-instance')
    end

  end

  # A locator instance
  class LocatorInstance < Shared::Instance

    private

    UPDATE_PAYLOAD_KEYS = ['bind-address',
                           'client-bind-address',
                           'client-port',
                           'initial-heap',
                           'jvm-options',
                           'max-heap',
                           'peer-discovery-address',
                           'peer-discovery-port',
                           'run-netserver']

    public

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
      super(location, client, Group, Installation, LocatorLiveConfigurations, LocatorPendingConfigurations, LocatorNodeInstance, 'locator-node-instance')
    end

    # Updates the instance using the supplied +options+.
    #
    # @param options [Hash] optional configuration for the instance
    #
    # @option options 'bind-address' [String] The property in a node's metadata to use to determine the address that the
    #   locator binds to for peer-to-peer communication. If omitted or +nil+, the configuration will not be changed. If
    #   set to an empty string the locator will use the value derived from +peer-discovery-address+.
    # @option options 'client-bind-address' [String] The property in a node's metadata to use to determine the address
    #   that the locator binds to for client communication. If omitted or +nil+, the configuration will not be changed.
    #   If set to an empty string the locator will use its node's hostname
    # @option options 'client-port' [Integer] The port that the locator listens on for client connections. If omitted or
    #   +nil+, the configuration will not be changed
    # @option options 'initial-heap' [String] The intial heap size to be used by the locator's JVM. If omitted or +nil+,
    #   the configuration will not be changed. If set to an empty string the JVM's default is used
    # @option options :installation [String] The installation to be used by the instance. If omitted or +nil+, the
    #   configuration will not be changed.
    # @option options 'jvm-options' [String[]] The JVM options that are passed to the locator's JVM when it is started.
    #   If omitted or +nil+, the configuration will not be changed
    # @option options 'max-heap' [String] The maximum heap size to be used by the locator's JVM. If omitted or +nil+, the
    #   configuration will not be changed. If set to an empty string the JVM's default is used
    # @option options 'peer-discovery-address' [String] The property in a node's metadata to use to determine the
    #   address that the locator binds to for peer-discovery communication. If omitted or +nil+, the configuration will
    #   not be changed. If set to an empty string the locator will use +0.0.0.0+
    # @option options 'peer-discovery-port' [Integer] The port that the locator listens on for peer-discovery
    #   connections. If omitted or +nil+, the configuration will not be changed
    # @option options 'run-netserver' [Boolean] Whether the locator should run a netserver that can service thin
    #   clients. If omitted or +nil+, the configuration will not be changed
    #
    # @return [void]
    def update(options)
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