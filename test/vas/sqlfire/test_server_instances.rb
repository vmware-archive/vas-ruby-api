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

  class TestServerInstances < VasTestCase

    def test_list
      server_instances = ServerInstances.new(
          'https://localhost:8443/sqlfire/v1/groups/1/server-instances/',
          StubClient.new)
      assert_count(2, server_instances)
      assert_equal('https://localhost:8443/vfabric/v1/security/3/', server_instances.security.location)
    end

    def test_create
      location = 'https://localhost:8443/sqlfire/v1/groups/1/server-instances/'
      installation_location = 'https://localhost:8443/sqlfire/v1/groups/1/installations/2/'
      instance_location = 'https://localhost:8443/sqlfire/v1/groups/1/server-instances/3/'

      client = StubClient.new

      installation = create_mock_with_location(installation_location)

      client.expect(:post, instance_location, [location, {:installation => installation_location, :name => 'test-instance'}, 'server-group-instance'])

      assert_equal(instance_location, ServerInstances.new(location, client).create(installation, 'test-instance').location)
    end

    def test_instance
      location = 'https://localhost:8443/sqlfire/v1/groups/2/server-instances/4/'

      client = StubClient.new

      instance = ServerInstance.new(location, client)

      assert_equal('example', instance.name)
      assert_equal(['-Da=alpha'], instance.jvm_options)
      assert_equal('bind.address', instance.bind_address)
      assert_equal('client.bind.address', instance.client_bind_address)
      assert_equal(1234, instance.client_port)
      assert_equal(90, instance.critical_heap_percentage)
      assert_equal(true, instance.run_netserver)
      assert_equal('512M', instance.initial_heap)
      assert_equal('1024M', instance.max_heap)

      assert_equal(2, instance.node_instances.size)
      assert_equal('https://localhost:8443/sqlfire/v1/nodes/1/server-instances/6/', instance.node_instances[0].location)
      assert_equal('https://localhost:8443/sqlfire/v1/nodes/0/server-instances/5/', instance.node_instances[1].location)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/2/', instance.group.location)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/2/installations/3/', instance.installation.location)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/2/server-instances/4/configurations/live/', instance.live_configurations.location)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/2/server-instances/4/configurations/pending/', instance.pending_configurations.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/7/', instance.security.location)

      assert_equal('STOPPED', instance.state)

      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/groups/2/server-instances/4/state/', {:status => 'STARTED'}])
      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/groups/2/server-instances/4/state/', {:status => 'STOPPED'}])

      instance.start
      instance.stop

      client.verify
    end

    def test_update_installation
      client = StubClient.new
      installation = create_mock_with_location('https://localhost:8443/sqlfire/v1/groups/1/installations/3/')
      instance = ServerInstance.new('https://localhost:8443/sqlfire/v1/groups/1/server-instances/2/', client)

      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/groups/1/server-instances/2/',
                                 {:installation => 'https://localhost:8443/sqlfire/v1/groups/1/installations/3/'}])

      instance.update({:installation => installation})

      client.verify
    end

    def test_update_with_bind_address
      do_test_update 'bind-address', 'bind.address'
    end

    def test_update_with_client_bind_address
      do_test_update 'client-bind-address', 'client.bind.address'
    end

    def test_update_with_client_port
      do_test_update 'client-port', 1234
    end

    def test_update_with_critical_heap_percentage
      do_test_update 'critical-heap-percentage', 85
    end

    def test_update_with_initial_heap
      do_test_update 'initial-heap', '1024M'
    end

    def test_update_with_jvm_options
      do_test_update 'jvm-options', ['-Da=alpha']
    end

    def test_update_with_max_heap
      do_test_update 'max-heap', '2048M'
    end

    def test_run_netserver
      do_test_update 'run-netserver', false
    end

    def do_test_update(key, value)
      client = StubClient.new
      installation = create_mock_with_location('https://localhost:8443/sqlfire/v1/groups/1/installations/3/')
      instance = ServerInstance.new('https://localhost:8443/sqlfire/v1/groups/1/server-instances/2/', client)

      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/groups/1/server-instances/2/',
                                 {key => value}])

      instance.update({key => value})

      client.verify
    end

    def test_delete
      client = StubClient.new
      server_instances = ServerInstances.new('https://localhost:8443/sqlfire/v1/groups/1/server-instances/', client)
      instance_location = 'https://localhost:8443/sqlfire/v1/groups/2/server-instances/4/'
      client.expect(:delete, nil, [instance_location])
      server_instances.delete(ServerInstance.new(instance_location, client))
      client.verify
    end

  end

end
