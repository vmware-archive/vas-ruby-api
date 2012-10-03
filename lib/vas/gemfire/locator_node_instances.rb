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

  # Used to enumerate locator instances on an individual node
  class LocatorNodeInstances < Shared::NodeInstances

    # @private
    def initialize(location, client)
      super(location, client, 'locator-node-instances', LocatorNodeInstance)
    end

  end

  # A locator node instance
  class LocatorNodeInstance < Shared::NodeInstance

    # @return [Integer] the port that the locator will listen on
    attr_reader :port

    # @return [Boolean] +true+ if the locator will act as a peer, +false+ if it will not
    attr_reader :peer

    # @return [Boolean] +true+ if the locator will act as a server, +false+ if it will not
    attr_reader :server

    # @private
    def initialize(location, client)
      super(location, client, Node, LocatorLogs, LocatorInstance, 'locator-group-instance', LocatorNodeLiveConfigurations)
    end

    # Reloads the instance's details from the server
    # @return [void]
    def reload
      super
      @port = details['port']
      @peer = details['peer']
      @server = details['server']
    end

    # @return [String] a string representation of the instance
    def to_s
      "#<#{self.class} name=#{name} port='#@port' peer='#@peer' server='#@server'>"
    end

  end

end