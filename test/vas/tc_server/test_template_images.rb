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

module TcServer
  
  class TestTemplateImages < VasTestCase
  
    def test_list
      template_images = TemplateImages.new(
          "https://localhost:8443/tc-server/v1/template-images/",
          StubClient.new)
      assert_count(2, template_images)
      assert_equal('https://localhost:8443/vfabric/v1/security/2/', template_images.security.location)
    end
  
    def test_create
      location = "https://localhost:8443/tc-server/v1/template-images/"
      client = StubClient.new
      path = "foo/template-image.txt"
  
      template_image_location = "https://localhost:8443/tc-server/v1/template-images/1/"
  
      client.expect(:post_image, template_image_location, [location, path, { :version => "1.2.3", :name => "test-template"}])
  
      assert_equal(template_image_location, TemplateImages.new(location, client).create(path, "test-template", "1.2.3").location)
    end
  
    def test_template_image
      location = "https://localhost:8443/tc-server/v1/template-images/1/"
      template_image = TemplateImage.new(location, StubClient.new)
      assert_equal(location, template_image.location)
      assert_equal("1.0.0", template_image.version)
      assert_equal("example", template_image.name)
      assert_equal(5673284, template_image.size)
      assert_equal(2, template_image.templates.size)
      assert_equal('https://localhost:8443/tc-server/v1/groups/4/installations/5/templates/6/', template_image.templates[0].location)
      assert_equal('https://localhost:8443/tc-server/v1/groups/1/installations/2/templates/3/', template_image.templates[1].location)
      assert_equal('https://localhost:8443/vfabric/v1/security/7/', template_image.security.location)
    end

    def test_delete
      client = StubClient.new
      template_images = TemplateImages.new('https://localhost:8443/tc-server/v1/template-images/', client)

      template_image_location = "https://localhost:8443/tc-server/v1/template-images/1/"
      client.expect(:delete, nil, [template_image_location])

      template_images.delete(TemplateImage.new(template_image_location, client))

      client.verify
    end
  
  end

end