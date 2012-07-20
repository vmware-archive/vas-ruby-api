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
  class TestRevisionImages < VasTestCase
  
    def test_list
      revision_images = RevisionImages.new(
          "https://localhost:8443/tc-server/v1/revision-images/",
          StubClient.new)
      assert_count(2, revision_images)
    end
  
    def test_create
      location = "https://localhost:8443/tc-server/v1/revision-images/"
      client = StubClient.new
      path = "foo/revision-image.txt"
  
      revision_image_location = "https://localhost:8443/tc-server/v1/revision-images/1/"
  
      client.expect(:post_image, revision_image_location, [location, path, { :version => "1.2.3", :name => "test-revision"}])
  
      assert_equal(revision_image_location, RevisionImages.new(location, client).create(path, "test-revision", "1.2.3").location)
    end
  
    def test_revision_image
      location = "https://localhost:8443/tc-server/v1/revision-images/1/"
      client = StubClient.new
  
      revision_image = RevisionImage.new(location, client)
      assert_equal(location, revision_image.location)
      assert_equal("1.0.0", revision_image.version)
      assert_equal("example", revision_image.name)

      assert_count(2, revision_image.revisions)
    end
  
  end
end
