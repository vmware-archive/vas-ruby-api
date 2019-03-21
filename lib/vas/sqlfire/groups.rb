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

  # Used to enumerate, create, and delete SQLFire groups.
  class Groups < Shared::Groups

    # @private
    def initialize(location, client)
      super(location, client, Group)
    end

  end

  # A SQLFire group
  class Group < Shared::MutableGroup

    # @private
    def initialize(location, client)
      super(location, client, Node, Installations)

      @agent_instances_location = Util::LinkUtils.get_link_href(details, 'agent-group-instances')
      @locator_instances_location = Util::LinkUtils.get_link_href(details, 'locator-group-instances')
      @server_instances_location = Util::LinkUtils.get_link_href(details, 'server-group-instances')
    end

    # @return [AgentInstances] the group's agent instances
    def agent_instances
      @agent_instances ||= AgentInstances.new(@agent_instances_location, client)
    end

    # @return [LocatorInstances] the group's locator instances
    def locator_instances
      @locator_instances ||= LocatorInstances.new(@locator_instances_location, client)
    end

    # @return [ServerInstances] the group's server instances
    def server_instances
      @server_instances ||= ServerInstances.new(@server_instances_location, client)
    end

  end

end