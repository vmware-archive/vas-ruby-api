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

  # Used to enumerate, create, and delete tc Server installations.
  class Installations < Shared::MutableCollection
    
    def initialize(location, client) #:nodoc:
      super(location, client, "installations")
    end
    
    # Creates an Installation from the InstallationImage +installation_image+
    def create(installation_image)
      Installation.new(client.post(location, { :image => installation_image.location }, "installation"), client)
    end
    
    private
    def create_entry(json)
      Installation.new(Util::LinkUtils.get_self_link_href(json), client)
    end
    
  end
  
  # A tc Server installation
  class Installation < Shared::Resource

    # The installation's version
    attr_reader :version

    # The versions of the tc Server runtime that are supported by the installation
    attr_reader :runtime_versions

    def initialize(location, client) #:nodoc:
      super(location, client)

      @version = details["version"]
      @runtime_versions = details["runtime-versions"]
      @templates_location = Util::LinkUtils.get_link_href(details, "templates")
      @installation_image_location = Util::LinkUtils.get_link_href(details, "installation-image")
    end
    
    # The installation's Templates
    def templates
      Templates.new(@templates_location, client)
    end

    # The installation image that was used to create the installation
    def installation_image
      InstallationImage.new(@installation_image_location, client)
    end

    def instances
      instances = []
      Util::LinkUtils.get_link_hrefs(client.get(location), "group-instance").each { |instance_location|
        instances << Instance.new(instance_location, client)
      }
      instances
    end
    
    def to_s #:nodoc:
      "#<#{self.class} version='#@version' runtime_versions='#@runtime_versions'>"
    end
    
  end
  
end