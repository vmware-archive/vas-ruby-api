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

# API for general purpose vFabric administration
module VFabric

  # The entry point of the vFabric API
  class VFabric < Shared::Resource

    # @return [Nodes] the nodes that are known to the server
    attr_reader :nodes

    # @return [AgentImage] the installation image for the vFabric Administration agent
    attr_reader :agent_image

    # @private
    def initialize(location, client)
      json = client.get(location)
      @nodes = Nodes.new(Util::LinkUtils.get_link_href(json, "nodes"), client)
      @agent_image = AgentImage.new(Util::LinkUtils.get_link_href(json, "agent-image"), client)
    end

  end

end
