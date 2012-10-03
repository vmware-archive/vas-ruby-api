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

  # Used to enumerate agent instances on an individual node
  class AgentNodeInstances < Shared::NodeInstances

    # @private
    def initialize(location, client)
      super(location, client, 'agent-node-instances', AgentNodeInstance)
    end

  end

  # An agent node instance
  class AgentNodeInstance < Shared::NodeInstance

    # @return [String[]] The JVM options that are passed to the agent's JVM when it is started
    attr_reader :jvm_options

    # @private
    def initialize(location, client)
      super(location, client, Node, AgentLogs, AgentInstance, 'agent-group-instance', AgentNodeLiveConfigurations)
    end

    # Reloads the agent instance's details from the server
    # @return [void]
    def reload
      super
      @jvm_options = details['jvm-options']
    end

    # @return [String] a string representation of the instance
    def to_s
      "#<#{self.class} name='#{name}' jvm_options='#@jvm_options'>"
    end

  end

end