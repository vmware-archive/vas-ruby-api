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

module RabbitMq

  # Used to enumerate, create, and delete Rabbit plugin images
  class PluginImages < Shared::MutableCollection

    def initialize(location, client) #:nodoc:
      super(location, client, "plugin-images", PluginImage)
    end
    
    # Creates a plugin image by uploading the file at the given +path+
    def create(path)
      PluginImage.new(client.post_image(location, path), client)
    end
    
  end
  
  # A plugin image
  class PluginImage < Shared::Resource

    # The plugin image's name
    attr_reader :name

    # The plugin image's version
    attr_reader :version

    # The plugin image's size
    attr_reader :size

    def initialize(location, client) #:nodoc:
      super(location, client)

      @name = details["name"]
      @version = details["version"]
      @size = details['size']
    end

    # The plugins that have been created from this plugin image
    def plugins
      plugins = []
      Util::LinkUtils.get_link_hrefs(client.get(location), "plugin").each { |plugin_location| plugins << Plugin.new(plugin_location, client)}
      plugins
    end

    def to_s #:nodoc:
      "#<#{self.class} name='#@name' version='#@version'>"
    end

  end

end