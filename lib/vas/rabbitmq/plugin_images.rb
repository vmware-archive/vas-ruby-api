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


module RabbitMq

  # Used to enumerate, create, and delete RabbitMQ plugin images
  class PluginImages < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, "plugin-images", PluginImage)
    end
    
    # Creates a new plugin image by uploading a file
    #
    # @param path [String] the path of the plugin +.ez+ file to upload
    #
    # @return [PluginImage] the new plugin image
    def create(path)
      create_image(path)
    end
    
  end
  
  # A plugin image
  class PluginImage < Shared::Resource

    include Shared::Deletable

    # The plugin image's name
    attr_reader :name

    # The plugin image's version
    attr_reader :version

    # The plugin image's size
    attr_reader :size

    # @private
    def initialize(location, client)
      super(location, client)

      @name = details['name']
      @version = details['version']
      @size = details['size']
    end

    # Reloads the plugin image's details from the server
    # @return [void]
    def reload
      super
      @plugins = nil
    end

    # @return [Plugin[]] the plugins that have been created from this plugin image
    def plugins
      @plugins ||= create_resources_from_links('plugin', Plugin)
    end

    # @return [String] a string representation of the plugin image
    def to_s
      "#<#{self.class} name='#@name' size='#@size' version='#@version'>"
    end

  end

end