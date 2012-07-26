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

  class TestPluginImages < VasTestCase
  
    def test_list
      plugin_images = PluginImages.new(
          "https://localhost:8443/rabbitmq/v1/plugin-images/",
          StubClient.new)
      assert_count(2, plugin_images)
    end
  
    def test_create
      location = "https://localhost:8443/rabbitmq/v1/plugin-images/"
      client = StubClient.new
      path = "foo/plugin-image.txt"
  
      plugin_image_location = "https://localhost:8443/rabbitmq/v1/plugin-images/1/"
  
      client.expect(:post_image, plugin_image_location, [location, path])
  
      assert_equal(plugin_image_location, PluginImages.new(location, client).create(path).location)
    end
  
    def test_plugin_image
      location = "https://localhost:8443/rabbitmq/v1/plugin-images/1/"
      client = StubClient.new
  
      plugin_image = PluginImage.new(location, client)
      assert_equal(location, plugin_image.location)
      assert_equal("1.0.0", plugin_image.version)
      assert_equal("example", plugin_image.name)

      assert_count(2, plugin_image.plugins)
    end
  
  end
end
