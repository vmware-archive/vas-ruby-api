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

  class TestInstances < VasTestCase

    def test_list
      instances = Instances.new(
          'https://localhost:8443/rabbitmq/v1/groups/1/instances/',
          StubClient.new)
      assert_count(2, instances)
    end

    def test_create
      location = 'https://localhost:8443/rabbitmq/v1/groups/1/instances/'
      installation_location = 'https://localhost:8443/rabbitmq/v1/groups/1/installations/2/'
      instance_location = 'https://localhost:8443/rabbitmq/v1/groups/1/instances/3/'

      client = StubClient.new

      installation = create_mock_with_location(installation_location)

      client.expect(:post, instance_location, [location, {:installation => installation_location, :name => 'test-instance'}, 'group-instance'])

      assert_equal(instance_location, Instances.new(location, client).create(installation, 'test-instance').location)
    end

    def test_instance
      location = 'https://localhost:8443/rabbitmq/v1/groups/1/instances/2/'

      client = StubClient.new

      instance = Instance.new(location, client)

      assert_equal('example', instance.name)
      assert_equal('https://localhost:8443/rabbitmq/v1/groups/2/installations/3/', instance.installation.location)
      assert_equal('https://localhost:8443/rabbitmq/v1/groups/2/', instance.group.location)
      assert_equal('STOPPED', instance.state)

      client.expect(:post, nil, ['https://localhost:8443/rabbitmq/v1/groups/2/instances/4/state/', {:status => 'STARTED'}])
      client.expect(:post, nil, ['https://localhost:8443/rabbitmq/v1/groups/2/instances/4/state/', {:status => 'STOPPED'}])

      instance.start
      instance.stop

      client.verify
    end

    def test_update
      client = StubClient.new
      installation = create_mock_with_location('https://localhost:8443/rabbitmq/v1/groups/1/installations/3/')
      instance = Instance.new('https://localhost:8443/rabbitmq/v1/groups/1/instances/2/', client)

      client.expect(:post, nil, ['https://localhost:8443/rabbitmq/v1/groups/1/instances/2/',
                                 {:installation => 'https://localhost:8443/rabbitmq/v1/groups/1/installations/3/'}])

      instance.update(installation)

      client.verify
    end

  end

end
