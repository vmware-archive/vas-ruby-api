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
      assert_equal('https://localhost:8443/vfabric/v1/security/2/', installation_images.security.location)
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
      assert_equal(7340032, installation_image.size)

      assert_count(2, installation_image.installations)
      assert_equal('https://localhost:8443/tc-server/v1/groups/1/installations/2/', installation_image.installations[0].location)
      assert_equal('https://localhost:8443/tc-server/v1/groups/3/installations/4/', installation_image.installations[1].location)
      assert_equal('https://localhost:8443/vfabric/v1/security/5/', installation_image.security.location)
    end

    def test_delete
      client = StubClient.new
      installation_image_location = "https://localhost:8443/tc-server/v1/installation-images/1/"
      client.expect(:delete, nil, [installation_image_location])
      InstallationImage.new(installation_image_location, client).delete
      client.verify
    end
  
  end
end