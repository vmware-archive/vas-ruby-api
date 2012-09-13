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


module Gemfire

  # Used to enumerate, create, and delete locator instances.
  class LocatorInstances < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, "locator-group-instances", LocatorInstance)
    end

    # Creates a new locator instance
    # @param installation [Installation] the installation that the instance will use
    # @param name [String] the name of the instance
    # @param options [Hash] optional configuration for the instance
    # @option options :peer (true) +true+ if the locator should act as a peer, otherwise +false+
    # @option options :port [Integer] (10334) the port that the locator will listen on
    # @option options :server (true) +true+ if the locator should act as a server, otherwise +false+
    # @return [LocatorInstance] the new instance
    def create(installation, name, options = {})
      payload = { :installation => installation.location, :name => name }

      if options.has_key?(:peer)
        payload[:peer] = options[:peer]
      end

      if options.has_key?(:port)
        payload[:port] = options[:port]
      end

      if options.has_key?(:server)
        payload[:server] = options[:server]
      end

      LocatorInstance.new(client.post(location, payload, "locator-group-instance"), client)
    end

  end

  # A locator instance
  class LocatorInstance < Shared::Instance

    # @private
    def initialize(location, client)
      super(location, client, Group, Installation, LocatorLiveConfigurations, LocatorPendingConfigurations, LocatorNodeInstance, 'locator-node-instance')
    end

    # Updates the instance using the supplied +options+.
    #
    # @param options [Hash] optional configuration for the instance
    #
    # @option options :installation [Installation] the installation to be used by the instance.
    #   If omitted or nil, the installation configuration will not be changed
    # @option options :peer +true+ if the locator should act as a peer, otherwise +false+.
    #   If omitted or nil, the installation configuration will not be changed
    # @option options :port [Integer] the port that the locator will listen on.
    #   If omitted or nil, the installation configuration will not be changed
    # @option options :server +true+ if the locator should act as a server, otherwise +false+.
    #   If omitted or nil, the installation configuration will not be changed
    def update(options)
      payload = {}

      if options.has_key?(:installation)
        payload[:installation] = options[:installation].location
      end

      if options.has_key?(:peer)
        payload[:peer] = options[:peer]
      end

      if options.has_key?(:port)
        payload[:port] = options[:port]
      end

      if options.has_key?(:server)
        payload[:server] = options[:server]
      end

      client.post(location, payload)
    end

    # @return [Integer] the port that the locator will listen on
    def port
      client.get(location)['port']
    end

    # @return [Boolean] +true+ if the locator will act as a peer, +false+ if it will not
    def peer
      client.get(location)['peer']
    end

    # @return [Boolean] +true+ if the locator will act as a server, +false+ if it will not
    def server
      client.get(location)['server']
    end

  end

end