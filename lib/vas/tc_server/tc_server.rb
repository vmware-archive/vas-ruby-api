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


# API for administering tc Server
module TcServer
  
  # The entry point to the API for administering tc Server
  class TcServer

    # @return [Groups] the tc Server groups
    attr_reader :groups

    # @return [InstallationImages] the tc Server installation images
    attr_reader :installation_images

    # @return [Nodes] the tc Server Nodes
    attr_reader :nodes

    # @return [RevisionImages] the tc Server revision images
    attr_reader :revision_images

    # @return [TemplateImages] the tc Server template images
    attr_reader :template_images
    
    # @private
    def initialize(location, client)

      json = client.get(location)
      
      @groups = Groups.new(Util::LinkUtils.get_link_href(json, "groups"), client)
      @installation_images = InstallationImages.new(Util::LinkUtils.get_link_href(json, "installation-images"), client)
      @nodes = Nodes.new(Util::LinkUtils.get_link_href(json, "nodes"), client)
      @revision_images = RevisionImages.new(Util::LinkUtils.get_link_href(json, "revision-images"), client)
      @template_images = TemplateImages.new(Util::LinkUtils.get_link_href(json, "template-images"), client)
    end
    
  end
end