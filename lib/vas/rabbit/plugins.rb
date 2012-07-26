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

module Rabbit

  # Used to enumerate, create, and delete plugins.
  class Plugins < Shared::Collection
    
    def initialize(location, client) #:nodoc:
      super(location, client, "plugins", Plugin)
    end

    # Creates a plugin from the +plugin_image+
    def create(plugin_image)
      Plugin.new(client.post(location, { :image => plugin_image.location}, 'plugin'), client)
    end
    
  end

  # A plugin in a Rabbit instance
  class Plugin < Shared::Resource

    # The plugin's version
    attr_reader :version

    # The plugin's name
    attr_reader :name
    
    def initialize(location, client) #:nodoc:
      super(location, client)
      
      @name = details['name']
      @version = details['version']
      @plugin_image_location = Util::LinkUtils.get_link_href(details, 'plugin-image')
      @instance_location = Util::LinkUtils.get_link_href(details, 'group-instance')
      @state_location = Util::LinkUtils.get_link_href(details, 'state')
    end

    # The plugin image, if any, that was used to create the plugin
    def plugin_image
      if (!@plugin_image_location.nil?)
        PluginImage.new(@plugin_image_location, client)
      end
    end

    # The instance that contains the plugin
    def instance
      Instance.new(@instance_location, client)
    end

    # The state of the plugin
    def state
      client.get(@state_location)['status']
    end

    # Enables the plugin
    def enable
      client.post(@state_location, { :status => 'ENABLED' })
    end

    # Disables the plugin
    def disable
      client.post(@state_location, { :status => 'DISABLED' })
    end
    
    def to_s #:nodoc:
      "#<#{self.class} name='#@name' version='#@version'>"
    end
  end

end