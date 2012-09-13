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


module Shared

  # @abstract A collection of installations
  class Installations < Shared::MutableCollection

    # @private
    def initialize(location, client, installation_class)
      super(location, client, "installations", installation_class)
    end

    # Creates a new installation
    #
    # @param installation_image [InstallationImage] the installation image to use to create the installation
    #
    # @return [Installation] the new installation
    def create(installation_image)
      entry_class.new(client.post(location, { :image => installation_image.location }, "installation"), client)
    end
    
  end

  # @abstract An installation of a middleware component. Created from an installation image. Once created, an
  #   installation is used when creating a new instance and provides the binaries that the instance uses at
  #   runtime
  class Installation < Shared::Resource

    # @return [String] the installation's version
    attr_reader :version

    # @return [InstallationImage] the installation image that was used to create the installation
    attr_reader :installation_image

    # @return [Group] the group that contains the installation
    attr_reader :group
    
    # @private
    def initialize(location, client, installation_image_class, group_class) #:nodoc:
      super(location, client)

      @version = details["version"]
      @installation_image = installation_image_class.new(Util::LinkUtils.get_link_href(details, "installation-image"), client)
      @group = group_class.new(Util::LinkUtils.get_link_href(details, "group"), client)
    end
    
    # @return [String] a string representation of the installation
    def to_s #:nodoc:
      "#<#{self.class} version='#@version'>"
    end
    
    private

    def retrieve_instances(instance_rel, instance_class)
      instances = []
      Util::LinkUtils.get_link_hrefs(client.get(location), instance_rel).each { |instance_location|
        instances << instance_class.new(instance_location, client)
      }
      instances
    end

  end
  
end