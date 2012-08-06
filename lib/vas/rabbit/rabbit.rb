#--
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
#++

module Rabbit

  class Rabbit
    # The Rabbit groups
    attr_reader :groups

    # The Rabbit installation images
    attr_reader :installation_images

    # The Rabbit plugin images
    attr_reader :plugin_images

    # The Rabbit nodes
    attr_reader :nodes

    def initialize(location, client) #:nodoc:

      json = client.get(location)

      @groups = Groups.new(Util::LinkUtils.get_link_href(json, "groups"), client)
      @installation_images = InstallationImages.new(Util::LinkUtils.get_link_href(json, "installation-images"), client)
      @plugin_images = PluginImages.new(Util::LinkUtils.get_link_href(json, "plugin-images"), client)
      @nodes = Nodes.new(Util::LinkUtils.get_link_href(json, "nodes"), client)
    end

  end

end
