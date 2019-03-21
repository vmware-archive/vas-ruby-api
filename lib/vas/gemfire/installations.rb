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


module Gemfire

  # Used to enumerate, create, and delete GemFire installations.
  class Installations < Shared::Installations

    # @private
    def initialize(location, client)
      super(location, client, Installation)
    end

  end

  # A GemFire installation
  class Installation < Shared::Installation

    # @private
    def initialize(location, client)
      super(location, client, InstallationImage, Group)
    end

    # Reloads the installation's details from the server
    # @return [void]
    def reload
      super
      @agent_instances = nil
      @cache_server_instances = nil
      @locator_instances = nil
    end

    # @return [AgentInstance[]] the agent instances that are using the installation
    def agent_instances
      @agent_instances ||= create_resources_from_links('agent-group-instance', AgentInstance);
    end

    # @return [CacheServerInstance[]] the cache server instances that are using the installation
    def cache_server_instances
      @cache_server_instances ||= create_resources_from_links('cache-server-group-instance', CacheServerInstance);
    end

    # @return [LocatorInstance[]] the locator instances that are using the installation
    def locator_instances
      @locator_instances ||= create_resources_from_links('locator-group-instance', LocatorInstance);
    end
    
  end
  
end