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


module Gemfire

  class TestApplicationCodeImages < VasTestCase
  
    def test_list
      application_code_images = ApplicationCodeImages.new(
          "https://localhost:8443/gemfire/v1/application-code-images/",
          StubClient.new)
      assert_count(2, application_code_images)
      assert_equal('https://localhost:8443/vfabric/v1/security/2/', application_code_images.security.location)
    end
  
    def test_create
      location = "https://localhost:8443/gemfire/v1/application-code-images/"
      client = StubClient.new
      path = "foo/installation-image.txt"
  
      installation_image_location = "https://localhost:8443/gemfire/v1/installation-images/1/"
  
      client.expect(:post_image, installation_image_location, [location, path, { :name => 'test', :version => '1.2.3'}])
  
      assert_equal(installation_image_location, ApplicationCodeImages.new(location, client).create(path, 'test', '1.2.3').location)
    end
  
    def test_application_code_image
      location = "https://localhost:8443/gemfire/v1/application-code-images/1/"
  
      application_code_image = ApplicationCodeImage.new(location, StubClient.new)
  
      assert_equal(location, application_code_image.location)
      assert_equal('example', application_code_image.name)
      assert_equal('1.0.0', application_code_image.version)
      assert_equal(5673284, application_code_image.size)

      assert_count(2, application_code_image.live_application_code)

      assert_equal('https://localhost:8443/gemfire/v1/groups/1/cache-server-instances/2/application-code/live/3/',
                   application_code_image.live_application_code[0].location)
      assert_equal('https://localhost:8443/gemfire/v1/groups/4/cache-server-instances/5/application-code/live/6/',
                   application_code_image.live_application_code[1].location)

      assert_count(2, application_code_image.pending_application_code)

      assert_equal('https://localhost:8443/gemfire/v1/groups/10/cache-server-instances/11/application-code/pending/12/',
                   application_code_image.pending_application_code[0].location)
      assert_equal('https://localhost:8443/gemfire/v1/groups/7/cache-server-instances/8/application-code/pending/9/',
                   application_code_image.pending_application_code[1].location)

      assert_equal('https://localhost:8443/vfabric/v1/security/13/', application_code_image.security.location)

    end

    def test_delete
      client = StubClient.new

      application_code_image_location = "https://localhost:8443/gemfire/v1/application-code-images/1/"
      client.expect(:delete, nil, [application_code_image_location])

      ApplicationCodeImage.new(application_code_image_location, client).delete

      client.verify
    end
  
  end
end