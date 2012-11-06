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

  # Used to enumerate cache server instances on an individual node
  class CacheServerNodeInstances < Shared::NodeInstances

    # @private
    def initialize(location, client)
      super(location, client, 'cache-server-node-instances', CacheServerNodeInstance)
    end

  end

  # A cache server node instance
  class CacheServerNodeInstance < Shared::NodeInstance

    # @private
    def initialize(location, client)
      super(location, client, Node, CacheServerLogs, CacheServerInstance, 'cache-server-group-instance',
            CacheServerNodeLiveConfigurations)

      @disk_stores_location = Util::LinkUtils.get_link_href(details, 'disk-stores')
      @statistics_location = Util::LinkUtils.get_link_href(details, 'statistics')

    end
    
    # Starts the cache server node instance, optionally triggering a rebalance
    #
    # @param rebalance [Boolean] +true+ if the start should trigger a rebalance, +false+ if it
    #   should not
    #
    # @return [void]
    def start(rebalance = false)
      client.post(@state_location, { :status => 'STARTED', :rebalance => rebalance })
    end

    # @return [DiskStores] the instance's disk stores
    def disk_stores
      @disk_stores ||= DiskStores.new(@disk_stores_location, client)
    end

    # @return [Statistics] the instance's statistics
    def statistics
      @statistics ||= Statistics.new(@statistics_location, client)
    end

  end

end