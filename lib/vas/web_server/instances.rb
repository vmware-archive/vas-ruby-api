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


module WebServer

  # Used to enumerate, create, and delete Web Server instances
  class Instances < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, "group-instances", Instance)
    end

    # Creates a new instance
    #
    # @param installation [Installation] the installation to be used by the instance
    # @param name [String] the name of the instance
    # @param properties [Hash] optional properties to use when creating the instance
    #
    # @return [Instance] the new instance
    def create(installation, name, properties = nil)
      payload = { :installation => installation.location,
                  :name => name}
      payload[:properties] = properties unless properties.nil?
      
      Instance.new(client.post(location, payload, "group-instance"), client)
    end

  end

  # A Web Server instance
  class Instance < Shared::Instance

    # @private
    def initialize(location, client)
      super(location, client, Group, Installation, LiveConfigurations, PendingConfigurations, NodeInstance, 'node-instance')
    end

    # Updates the installation used by the instance
    #
    # @param installation [Installation] the installation to be used by the instance
    #
    # @return [void]
    def update(installation)
      payload = { :installation => installation.location }
      client.post(location, payload);
    end

  end

end