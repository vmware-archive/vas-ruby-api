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

  # Used to enumerate, create, and delete agent instances.
  class AgentInstances < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, 'agent-group-instances', AgentInstance)
    end

    # Creates a new agent instance
    #
    # @param installation [Installation] the installation to be used by the instance
    # @param name [String] the name of the instance
    # @param options [Hash] optional configuration for the instance
    #
    # @option options 'jvm-options' [String[]] The JVM options that are passed to the agents's JVM when it is started

    # @return [AgentInstance] the new agent instance
    def create(installation, name, options = {})
      payload = { :installation => installation.location, :name => name }

      if options.has_key? 'jvm-options'
        payload['jvm-options'] = options['jvm-options']
      end

      super(payload, 'agent-group-instance')
    end

  end

  # An agent instance
  class AgentInstance < Shared::Instance

    # @return [String[]] The JVM options that are passed to the agent's JVM when it is started
    attr_reader :jvm_options

    # @private
    def initialize(location, client)
      super(location, client, Group, Installation, AgentLiveConfigurations, AgentPendingConfigurations, AgentNodeInstance, 'agent-node-instance')
    end

    # Reloads the agent instance's details from the server
    # @return [void]
    def reload
      super
      @jvm_options = details['jvm-options']
    end

    # Updates the instance using the supplied +options+
    #
    # @param options [Hash] optional configuration for the instance
    #
    # @option options :installation [String] The installation to be used by the instance. If omitted or +nil+, the
    #   configuration will not be changed.
    # @option options 'jvm-options' [String[]] The JVM options that are passed to the agent's JVM when it is started.
    #   If omitted or +nil+, the configuration will not be changed
    #
    # @return [void]
    def update(options = {})
      payload = {}

      if options.has_key? 'jvm-options'
        payload['jvm-options'] = options['jvm-options']
      end

      if options.has_key? :installation
        payload[:installation] = options[:installation].location
      end

      client.post(location, payload)
      reload
    end

    # @return [String] a string representation of the instance
    def to_s
      "#<#{self.class} name='#{name}' jvm_options='#@jvm_options'>"
    end

  end

end