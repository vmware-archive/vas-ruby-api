# vFabric Administration Server Ruby API
# Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


module RabbitMq

  class TestPlugins < VasTestCase

    def test_list
      plugins = Plugins.new(
          'https://localhost:8443/rabbitmq/v1/groups/1/instances/2/plugins/',
          StubClient.new)
      assert_count(3, plugins)
      assert_equal('https://localhost:8443/vfabric/v1/security/6/', plugins.security.location)
    end

    def test_create
      location = 'https://localhost:8443/rabbitmq/v1/groups/1/instances/2/plugins/'
      plugin_image_location = 'https://localhost:8443/rabbitmq/v1/plugin-images/1'

      client = StubClient.new

      plugin_location = 'https://localhost:8443/rabbitmq/v1/groups/1/instances/2/plugins/3/'

      plugin_image = create_mock_with_location(plugin_image_location)

      client.expect(:post, plugin_location, [location, {:image => plugin_image_location}, "plugin"])

      assert_equal(plugin_location, Plugins.new(location, client).create(plugin_image).location)
    end

    def test_plugin

      client = StubClient.new

      plugin = Plugin.new(
          'https://localhost:8443/rabbitmq/v1/groups/1/instances/2/plugins/3/', client)

      assert_equal('https://localhost:8443/rabbitmq/v1/groups/1/instances/2/plugins/3/', plugin.location)
      assert_equal('1.0.0', plugin.version)
      assert_equal('https://localhost:8443/rabbitmq/v1/plugin-images/0/', plugin.plugin_image.location)
      assert_equal('https://localhost:8443/rabbitmq/v1/groups/1/instances/2/', plugin.instance.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/4/', plugin.security.location)

      assert_equal('ENABLED', plugin.state)

      client.expect(:post, nil, ['https://localhost:8443/rabbitmq/v1/groups/1/instances/2/plugins/3/state/', {:status => 'ENABLED'}])
      client.expect(:post, nil, ['https://localhost:8443/rabbitmq/v1/groups/1/instances/2/plugins/3/state/', {:status => 'DISABLED'}])

      plugin.enable
      plugin.disable

      client.verify

    end

    def test_delete
      client = StubClient.new

      location = 'https://localhost:8443/rabbitmq/v1/groups/1/instances/2/plugins/3/'
      client.expect(:delete, nil, [location])

      Plugin.new(location, client).delete

      client.verify
    end

  end

end