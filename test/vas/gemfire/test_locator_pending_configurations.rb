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


module Gemfire
  
  class TestLocatorPendingConfigurations < VasTestCase
  
    def test_list
      configurations = LocatorPendingConfigurations.new(
          'https://localhost:8443/gemfire/v1/groups/1/locator-instances/2/configurations/pending/',
          StubClient.new)
      assert_count(1, configurations)
      assert_equal('https://localhost:8443/vfabric/v1/security/3/', configurations.security.location)
    end

    def test_create
      client = StubClient.new
      pending_configurations_location = 'https://localhost:8443/gemfire/v1/groups/1/locator-instances/2/configurations/pending/'
      configurations = LocatorPendingConfigurations.new(pending_configurations_location, client)

      created_location = "#{pending_configurations_location}3/"
      client.expect(:post_image, created_location, [pending_configurations_location, 'new content', { :path => "new/path"}])

      assert_equal(created_location, configurations.create('new/path', 'new content').location)
    end
  
    def test_pending_configuration
      location = 'https://localhost:8443/gemfire/v1/groups/0/locator-instances/1/configurations/pending/2/'

      client = StubClient.new
      pending_configuration = LocatorPendingConfiguration.new(location, client)
  
      assert_equal('https://localhost:8443/gemfire/v1/groups/0/locator-instances/1/configurations/pending/2/', pending_configuration.location)
      assert_equal('gemfire.properties', pending_configuration.path)
      assert_equal(10537, pending_configuration.size)
      assert_equal('https://localhost:8443/gemfire/v1/groups/0/locator-instances/1/', pending_configuration.instance.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/3/', pending_configuration.security.location)
  
      content = ''
      pending_configuration.content { |chunk| content << chunk}
      assert_equal('somestreamedcontent', content)

      client.expect(:post, nil, ['https://localhost:8443/gemfire/v1/groups/0/locator-instances/1/configurations/pending/2/content/', 'the new content'])
      pending_configuration.content = 'the new content'
      client.verify

    end

    def test_delete
      client = StubClient.new

      location = 'https://localhost:8443/gemfire/v1/groups/0/locator-instances/1/configurations/pending/2/'
      client.expect(:delete, nil, [location])

      LocatorPendingConfiguration.new(location, client).delete

      client.verify
    end
  
  end
end
