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

  # Used to enumerate, create, and delete GemFire groups.
  class Groups < Shared::Groups

    # @private
    def initialize(location, client)
      super(location, client, Group)
    end

  end

  # A GemFire group
  class Group < Shared::MutableGroup

    # @return [AgentInstances] the group's agent instances
    attr_reader :agent_instances

    # @return [CacheServerInstances] the group's cache server instances
    attr_reader :cache_server_instances

    # @return [LocatorInstances] the group's locator instances
    attr_reader :locator_instances

    # @private
    def initialize(location, client)
      super(location, client, Node, Installations)
      @agent_instances = AgentInstances.new(Util::LinkUtils.get_link_href(details, "agent-group-instances"), client)
      @cache_server_instances = CacheServerInstances.new(Util::LinkUtils.get_link_href(details, "cache-server-group-instances"), client)
      @locator_instances = LocatorInstances.new(Util::LinkUtils.get_link_href(details, "locator-group-instances"), client)
    end

  end

end