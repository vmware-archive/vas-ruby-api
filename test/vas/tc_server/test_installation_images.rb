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
  class TestInstallationImages < VasTestCase
  
    def test_list
      installation_images = InstallationImages.new(
          "https://localhost:8443/tc-server/v1/installation-images/",
          StubClient.new)
      assert_count(2, installation_images)
    end
  
    def test_create
      location = "https://localhost:8443/tc-server/v1/installation-images/"
      client = StubClient.new
      path = "foo/installation-image.txt"
  
      installation_image_location = "https://localhost:8443/tc-server/v1/installation-images/1/"
  
      client.expect(:post_image, installation_image_location, [location, path, { :version => "1.2.3"}])
  
      assert_equal(installation_image_location, InstallationImages.new(location, client).create(path, "1.2.3").location)
    end
  
    def test_installation_image
      location = "https://localhost:8443/tc-server/v1/installation-images/1/"
  
      installation_image = InstallationImage.new(location, StubClient.new)
  
      assert_equal(location, installation_image.location)
      assert_equal("2.7.0.RELEASE", installation_image.version)

      assert_count(2, installation_image.installations)
    end
  
  end
end