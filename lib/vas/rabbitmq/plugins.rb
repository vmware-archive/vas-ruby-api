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

  # Used to enumerate, create, and delete plugins
  class Plugins < Shared::MutableCollection

    def initialize(location, client)
      super(location, client, 'plugins', Plugin)
    end

    # Creates a plugin from the +plugin_image+
    # @return [Plugin] the new plugin
    def create(plugin_image)
      super({:image => plugin_image.location}, 'plugin')
    end

  end

  # A plugin in a RabbitMQ instance
  class Plugin < Shared::Resource

    # @return [String] the plugin's version
    attr_reader :version

    # @return [String] the plugin's name
    attr_reader :name

    # @private
    def initialize(location, client)
      super(location, client)

      @name = details['name']
      @version = details['version']

      @instance_location = Util::LinkUtils.get_link_href(details, 'group-instance')
      @state_location = Util::LinkUtils.get_link_href(details, 'state')
    end

    # @return [PluginImage] the plugin image, if any, that was used to create the plugin
    def plugin_image
      if @plugin_image.nil?
        plugin_image_location = Util::LinkUtils.get_link_href(details, 'plugin-image')
        @plugin_image = PluginImage.new(plugin_image_location, client) unless plugin_image_location.nil?
      end
      @plugin_image
    end

    # @return [Instance] the instance that contains the plugin
    def instance
      @instance ||= Instance.new(@instance_location, client)
    end

    # @return [String] the state of the plugin
    def state
      client.get(@state_location)['status']
    end

    # Enables the plugin
    #
    # @return [void]
    def enable
      client.post(@state_location, {:status => 'ENABLED'})
    end

    # Disables the plugin
    #
    # @return [void]
    def disable
      client.post(@state_location, {:status => 'DISABLED'})
    end

    # @return [String] a string representation of the plugin
    def to_s
      "#<#{self.class} name='#@name' version='#@version'>"
    end
  end

end