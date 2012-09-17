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

  class TestPendingApplicationCode < VasTestCase

    def test_list
      application_code = PendingApplicationCodes.new(
          'https://localhost:8443/gemfire/v1/groups/1/cache-server-instances/2/application-code/pending/',
          StubClient.new)
      assert_count(2, application_code)
      assert_equal('https://localhost:8443/vfabric/v1/security/4/', application_code.security.location)
    end

    def test_create
      location = 'https://localhost:8443/gemfire/v1/groups/1/cache-server/instances/2/application-code/pending/'
      application_code_image_location = 'https://localhost:8443/gemfire/v1/application-code-images/1'

      client = StubClient.new

      application_code_location = 'https://localhost:8443/gemfire/v1/groups/1/cache-server/instances/2/application-code/pending/3/'

      application_code_image = create_mock_with_location(application_code_image_location)

      client.expect(:post, application_code_location, [location, {:image => application_code_image_location}])

      assert_equal(application_code_location, PendingApplicationCodes.new(location, client).create(application_code_image).location)
    end
  
    def test_pending_application_code
      location = 'https://localhost:8443/gemfire/v1/groups/1/cache-server-instances/2/application-code/pending/3/'
  
      pending_application_code = ApplicationCode.new(location, StubClient.new)

      assert_equal('example', pending_application_code.name)
      assert_equal('1.0.0', pending_application_code.version)

      assert_equal('https://localhost:8443/gemfire/v1/groups/1/cache-server-instances/2/', pending_application_code.instance.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/4/', pending_application_code.security.location)
      assert_equal('https://localhost:8443/gemfire/v1/groups/1/cache-server-instances/2/application-code/pending/3/', pending_application_code.location)
    end

    def test_delete
      client = StubClient.new
      application_code = PendingApplicationCodes.new(
          'https://localhost:8443/gemfire/v1/groups/1/cache-server-instances/2/application-code/pending/', client)

      location = 'https://localhost:8443/gemfire/v1/groups/0/cache-server-instances/1/application-code/pending/2/'
      client.expect(:delete, nil, [location])

      application_code.delete(ApplicationCode.new(location, client))

      client.verify
    end
  
  end
end
