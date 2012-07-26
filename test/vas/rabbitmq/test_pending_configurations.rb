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
  
  class TestPendingConfigurations < VasTestCase
  
    def test_list
      configurations = PendingConfigurations.new(
          'https://localhost:8443/rabbitmq/v1/groups/1/instances/2/configurations/pending/',
          StubClient.new)
      assert_count(1, configurations)
    end
  
    def test_pending_configuration
      location = 'https://localhost:8443/rabbitmq/v1/groups/0/instances/1/configurations/pending/2/'

      client = StubClient.new
      pending_configuration = PendingConfiguration.new(location, client)
  
      assert_equal('https://localhost:8443/rabbitmq/v1/groups/0/instances/1/configurations/pending/2/', pending_configuration.location)
      assert_equal('conf/rabbitmq.config', pending_configuration.path)
      assert_equal(10537, pending_configuration.size)
      assert_equal('https://localhost:8443/rabbitmq/v1/groups/0/instances/1/', pending_configuration.instance.location)
  
      content = ''
  
      pending_configuration.content { |chunk| content << chunk}
  
      assert_equal('somestreamedcontent', content)

      client.expect(:post, nil, ['https://localhost:8443/rabbitmq/v1/groups/0/instances/1/configurations/pending/2/content/', 'the new content'])

      pending_configuration.content = 'the new content'

      client.verify
    end
  
  end
end
