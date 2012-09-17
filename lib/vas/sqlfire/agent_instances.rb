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

  # Used to enumerate, create, and delete agent instances.
  class AgentInstances < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, "agent-group-instances", AgentInstance)
    end

    # Creates a new agent instance
    #
    # @param installation [Installation] the installation to be used by the instance
    # @param name [String] the name of the instance
    # 
    # @return [AgentInstance] the new agent instance
    def create(installation, name)
      payload = { :installation => installation.location, :name => name }
      AgentInstance.new(client.post(location, payload, "agent-group-instance"), client)
    end

  end

  # An agent instance
  class AgentInstance < Shared::Instance

    # @private
    def initialize(location, client)
      super(location, client, Group, Installation, AgentLiveConfigurations, AgentPendingConfigurations, AgentNodeInstance, 'agent-node-instance')
    end

    # Updates the instance to use a different installation
    #
    # @param installation [Installation] the installation that the instance should use
    #
    # @return [void]
    def update(installation)
      client.post(location, { :installation => installation.location });
    end

  end

end