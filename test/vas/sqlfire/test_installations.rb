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


module Sqlfire

  class TestInstallations < VasTestCase
  
    def test_list
      installations = Installations.new(
          'https://localhost:8443/sqlfire/v1/groups/1/installations/',
          StubClient.new)
      assert_count(2, installations)

      assert_equal('https://localhost:8443/vfabric/v1/security/3/', installations.security.location)
    end
  
    def test_create
      location = 'https://localhost:8443/sqlfire/v1/groups/1/installations/'
      installation_image_location = 'https://localhost:8443/sqlfire/v1/installation-images/1/'
  
      client = StubClient.new
  
      installation_image = create_mock_with_location(installation_image_location)
  
      installation_location = 'https://localhost:8443/sqlfire/v1/groups/1/installations/2/'
  
      client.expect(:post, installation_location, [location, { :image => installation_image_location }, 'installation'])
  
      assert_equal(installation_location, Installations.new(location, client).create(installation_image).location)
    end
  
    def test_installation
      installation = Installation.new('https://localhost:8443/sqlfire/v1/groups/1/installations/2/', StubClient.new)
      assert_equal('6.6.1', installation.version)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/1/installations/2/', installation.location)
      assert_equal('https://localhost:8443/sqlfire/v1/installation-images/0/', installation.installation_image.location)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/1/', installation.group.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/7/', installation.security.location)
      assert_count(1, installation.agent_instances)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/1/agent-instances/3/', installation.agent_instances[0].location)
      assert_count(2, installation.locator_instances)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/1/locator-instances/6/', installation.locator_instances[0].location)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/1/locator-instances/5/', installation.locator_instances[1].location)
      assert_count(1, installation.server_instances)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/1/server-instances/4/', installation.server_instances[0].location)
    end

    def test_delete
      client = StubClient.new

      installation_location = 'https://localhost:8443/sqlfire/v1/groups/1/installations/2/'
      client.expect(:delete, nil, [installation_location])

      Installation.new(installation_location, client).delete

      client.verify
    end
  
  end

end
