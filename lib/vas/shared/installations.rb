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
      super(location, client, 'installations', installation_class)
    end

    # Creates a new installation
    #
    # @param installation_image [InstallationImage] the installation image to use to create the installation
    #
    # @return [Installation] the new installation
    def create(installation_image)
      super({ :image => installation_image.location }, 'installation')
    end
    
  end

  # @abstract An installation of a middleware component. Created from an installation image. Once created, an
  #   installation is used when creating a new instance and provides the binaries that the instance uses at
  #   runtime
  class Installation < Shared::Resource

    # @return [String] the installation's version
    attr_reader :version
    
    # @private
    def initialize(location, client, installation_image_class, group_class)
      super(location, client)

      @installation_image_location = Util::LinkUtils.get_link_href(details, 'installation-image')
      @group_location = Util::LinkUtils.get_link_href(details, 'group')

      @installation_image_class = installation_image_class
      @group_class = group_class

      @version = details['version']
    end

    # @return [Group] the group that contains the installation
    def group
      @group ||= @group_class.new(@group_location, client)
    end

    # @return [InstallationImage] the installation image that was used to create the installation
    def installation_image
      @installation_image ||= @installation_image_class.new(@installation_image_location, client)
    end
    
    # @return [String] a string representation of the installation
    def to_s #:nodoc:
      "#<#{self.class} version='#@version'>"
    end

  end
  
end