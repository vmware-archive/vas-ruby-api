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

  # Used to enumerate, create, and delete tc Server template images.
  class TemplateImages < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, 'template-images', TemplateImage)
    end
    
    # Creates a new template image by uploading a +.zip+ file to the server
    #
    # @param path [String] the path of the template image +.zip+ file
    # @param name [String] the name of the template image
    # @param version [String] the version of the template image
    #
    # @return [TemplateImage] the new template image
    def create(path, name, version)
      create_image(path, { :name => name, :version => version })
    end
    
  end
  
  # A template image
  class TemplateImage < Shared::Resource

    # @return [String] the template image's name
    attr_reader :name

    # @return [String] the template image's version
    attr_reader :version

    # @return [String] the template image's size
    attr_reader :size

    # @private
    def initialize(location, client)
      super(location, client)

      @name = details['name']
      @version = details['version']
      @size = details['size']
    end

    # Reloads the template image's details from the server
    def reload
      super
      @templates = nil
    end

    # @return [Template[]] the templates that have been created from the template image
    def templates
      @templates ||= create_resources_from_links('template', Template)
    end

    # @return [String] a string representation of the template image
    def to_s
      "#<#{self.class} name='#@name' version='#@version' size='#@size'>"
    end

  end

end