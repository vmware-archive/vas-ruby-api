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

  # Used to enumerate a server instance's live configuration
  class ServerLiveConfigurations < Shared::Collection

    # @private
    def initialize(location, client)
      super(location, client, "live-configurations", ServerLiveConfiguration)
    end

  end
  
  # A live configuration file in a server instance
  class ServerLiveConfiguration < Shared::Configuration

    # @private
    def initialize(location, client)
      super(location, client, "server-group-instance", ServerInstance)
    end

  end

end