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

  # Used to enumerate, create, and delete SQLFire installations.
  class Installations < Shared::Installations

    # @private
    def initialize(location, client)
      super(location, client, Installation)
    end

  end

  # A SQLFire installation
  class Installation < Shared::Installation

    # @private
    def initialize(location, client)
      super(location, client, InstallationImage, Group)
    end

    def reload
      super
      @agent_instances = nil
      @locator_instances = nil
      @server_instances = nil
    end

    # @return [AgentInstance[]] the agent instances that are using the installation
    def agent_instances
      @agent_instances ||= create_resources_from_links('agent-group-instance', AgentInstance);
    end

    # @return [LocatorInstance[]] the locator instances that are using the installation
    def locator_instances
      @locator_instances ||= create_resources_from_links('locator-group-instance', LocatorInstance);
    end

    # @return [ServerInstance[]] the server instances that are using the installation
    def server_instances
      @server_instances ||= create_resources_from_links('server-group-instance', ServerInstance);
    end
    
  end
  
end