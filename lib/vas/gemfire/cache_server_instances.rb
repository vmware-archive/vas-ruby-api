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

  # Used to enumerate, create, and delete cache server instances.
  class CacheServerInstances < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, 'cache-server-group-instances', CacheServerInstance)
    end

    # Creates a new cache server instance
    #
    # @param installation [Installation] the installation to be used by the instance
    # @param name [String] the name of the instance
    #
    # @return [CacheServerInstance] the new cache server instance
    def create(installation, name)
      payload = { :installation => installation.location, :name => name }
      super(payload, 'cache-server-group-instance')
    end

  end

  # A cache server instance
  class CacheServerInstance < Shared::Instance

    # @private
    def initialize(location, client)
      super(location, client, Group, Installation, CacheServerLiveConfigurations, CacheServerPendingConfigurations,
            CacheServerNodeInstance, 'cache-server-node-instance')

      @live_application_code_location = Util::LinkUtils.get_link_href(details, 'live-application-code')
      @pending_application_code_location = Util::LinkUtils.get_link_href(details, 'pending-application-code')

    end

    # Updates the instance to use a different installation
    #
    # @param installation [Installation] the installation that the instance should use
    #
    # @return [void]
    def update(installation)
      client.post(location, { :installation => installation.location })
      reload
    end

    # @return [LiveApplicationCodes] the instance's live application code
    def live_application_code
      @live_application_code ||= LiveApplicationCodes.new(@live_application_code_location, client)
    end

    # @return [PendingApplicationCodes] the instance's pending application code
    def pending_application_code
      @pending_application_code ||= PendingApplicationCodes.new(@pending_application_code_location, client)
    end

  end

end