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

  # @abstract A collection of installation images
  class InstallationImages < MutableCollection
  
    # @private
    def initialize(location, client, installation_image_class)
      super(location, client, 'installation-images', installation_image_class)
    end

    # Creates an installation image by uploading a file to the server and assigning it a version
    #
    # @param path the path of the file to upload
    # @param version [String] the installation image's version
    #
    # @return [InstallationImage] the new installation image
    def create(path, version)
      create_image(path, { :version => version })
    end

  end

  # @abstract A product binary, typically are .zip or .tar.gz file, that has been uploaded to the
  #   server. Once created, an installation image can then be used to create an installation on a
  #   group.
  class InstallationImage < Resource
    
    include Deletable
    
    # @return [String] the installation image's version
    attr_reader :version

    # @return [Integer] the installation image's size
    attr_reader :size

    # @private
    def initialize(location, client, installation_class) #:nodoc:
      super(location, client)

      @installation_class = installation_class

      @version = details['version']
      @size = details['size']
    end

    # Reloads the installation image's details from the server
    #
    # @return [void]
    def reload
      super
      @installations = nil
    end

    # @return [Installation[]] the installations that have been created from the installation image
    def installations
      @installations ||= create_resources_from_links('installation', @installation_class)
    end

    # @return [String] a string representation of the installation image
    def to_s
      "#<#{self.class} version='#@version' size='#@size'>"
    end

  end

end