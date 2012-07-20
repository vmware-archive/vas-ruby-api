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

module TcServer

  # Used to enumerate an Instance's pending configuration
  class PendingConfigurations < Shared::MutableCollection

    def initialize(location, client) #:nodoc:
      super(location, client, "pending-configurations")
    end

    private
    def create_entry(json)
      PendingConfiguration.new(Util::LinkUtils.get_self_link_href(json), client)
    end

  end

  # A configuration file that is pending
  class PendingConfiguration < Configuration

    # Updates the configuration to contain +new_content+
    def content=(new_content)
      client.post(@content_location, new_content)
      @size = client.get(location)['size']
    end
  end
end