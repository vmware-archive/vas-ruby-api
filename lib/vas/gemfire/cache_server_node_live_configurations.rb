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

  # Used to enumerate a cache server node instance's live configuration
  class CacheServerNodeLiveConfigurations < Shared::Collection

    # @private
    def initialize(location, client)
      super(location, client, 'node-live-configurations', CacheServerNodeLiveConfiguration)
    end

  end
  
  # A live configuration file in a cache server node instance
  class CacheServerNodeLiveConfiguration < Shared::NodeConfiguration

    # @private
    def initialize(location, client)
      super(location, client, 'cache-server-node-instance', CacheServerNodeInstance, CacheServerLiveConfiguration)
    end

  end

end