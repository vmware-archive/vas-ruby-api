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
      super(location, client, "locator-group-instances", LocatorInstance)
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

      LocatorInstance.new(client.post(location, payload, "locator-group-instance"), client)
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
    #   If omitted or +nil+, the configuration will not be chanaged
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