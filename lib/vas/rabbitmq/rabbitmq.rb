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


# API for administering RabbitMQ
module RabbitMq

  # The entry point to the API for administering RabbitMQ
  class RabbitMq
    
    # @return [Groups] the RabbitMQ groups
    attr_reader :groups

    # @return [InstallationImages] the RabbitMQ installation images
    attr_reader :installation_images

    # @return [PluginImages] the RabbitMQ plugin images
    attr_reader :plugin_images

    # @return [Nodes] the RabbitMQ nodes
    attr_reader :nodes

    # @private
    def initialize(location, client)

      json = client.get(location)

      @groups = Groups.new(Util::LinkUtils.get_link_href(json, "groups"), client)
      @installation_images = InstallationImages.new(Util::LinkUtils.get_link_href(json, "installation-images"), client)
      @plugin_images = PluginImages.new(Util::LinkUtils.get_link_href(json, "plugin-images"), client)
      @nodes = Nodes.new(Util::LinkUtils.get_link_href(json, "nodes"), client)
    end

  end

end
