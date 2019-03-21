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

  # Used to enumerate an agent node instance's live configuration
  class AgentNodeLiveConfigurations < Shared::Collection

    # @private
    def initialize(location, client)
      super(location, client, 'node-live-configurations', AgentNodeLiveConfiguration)
    end

  end
  
  # A live configuration file in an agent node instance
  class AgentNodeLiveConfiguration < Shared::NodeConfiguration

    # @private
    def initialize(location, client)
      super(location, client, 'agent-node-instance', AgentNodeInstance, AgentLiveConfiguration)
    end

  end

end