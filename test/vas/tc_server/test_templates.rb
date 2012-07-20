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
  class TestTemplates < VasTestCase
  
    def test_list
      templates = Templates.new(
          'https://localhost:8443/tc-server/v1/groups/1/installations/2/templates/',
          StubClient.new)
      assert_count(3, templates)
    end
  
    def test_create
      location = 'https://localhost:8443/tc-server/v1/groups/1/installations/2/templates/'
      template_image_location = 'https://localhost:8443/tc-server/v1/template-images/1/'
  
      client = StubClient.new
  
      template_location = 'https://localhost:8443/tc-server/v1/groups/1/installations/2/templates/3/'
  
      template_image = create_mock_with_location(template_image_location)
  
      client.expect(:post, template_location, [location, { :image => template_image_location }, 'template'])
  
      assert_equal(template_location, Templates.new(location, client).create(template_image).location)
    end
  
    def test_template
      location = 'https://localhost:8443/tc-server/v1/groups/1/installations/2/templates/3/'
  
      template = Template.new(location, StubClient.new)
  
      assert_equal('https://localhost:8443/tc-server/v1/groups/1/installations/2/templates/3/', template.location)
      assert_equal('example', template.name)
      assert_equal('1.0.0', template.version)
      assert_equal('https://localhost:8443/tc-server/v1/template-images/0/', template.template_image.location)
  
    end
  
  end
end