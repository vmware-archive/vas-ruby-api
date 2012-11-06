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

  class TestLocatorInstances < VasTestCase

    def test_list
      locator_instances = LocatorInstances.new(
          'https://localhost:8443/sqlfire/v1/groups/1/locator-instances/',
          StubClient.new)
      assert_count(2, locator_instances)
      assert_equal('https://localhost:8443/vfabric/v1/security/3/', locator_instances.security.location)
    end

    def test_create
      location = 'https://localhost:8443/sqlfire/v1/groups/1/locator-instances/'
      installation_location = 'https://localhost:8443/sqlfire/v1/groups/1/installations/2/'
      instance_location = 'https://localhost:8443/sqlfire/v1/groups/1/locator-instances/3/'

      client = StubClient.new

      installation = create_mock_with_location(installation_location)

      client.expect(:post, instance_location, [location, {:installation => installation_location, :name => 'test-instance'}, 'locator-group-instance'])

      assert_equal(instance_location, LocatorInstances.new(location, client).create(installation, 'test-instance').location)
    end

    def test_create_with_bind_address
      do_test_create 'bind-address', 'bind.address'
    end

    def test_create_with_client_bind_address
      do_test_create 'client-bind-address', 'client.bind.address'
    end

    def test_create_with_client_port
      do_test_create 'client-port', 1234
    end

    def test_create_with_initial_heap
      do_test_create 'initial-heap', '1024M'
    end

    def test_create_with_jvm_options
      do_test_create 'jvm-options', ['-Da=alpha', '-Db=bravo']
    end

    def test_create_with_max_heap
      do_test_create 'max-heap', '2048M'
    end

    def test_create_with_peer_discovery_address
      do_test_create 'peer-discovery-address', 'peer.discovery.address'
    end

    def test_create_with_peer_discovery_port
      do_test_create 'peer-discovery-port', 1234
    end

    def test_create_with_run_netserver
      do_test_create 'run-netserver', false
    end

    def do_test_create(key, value)
      location = 'https://localhost:8443/sqlfire/v1/groups/1/locator-instances/'
      installation_location = 'https://localhost:8443/sqlfire/v1/groups/1/installations/2/'
      instance_location = 'https://localhost:8443/sqlfire/v1/groups/1/locator-instances/3/'

      client = StubClient.new

      installation = create_mock_with_location(installation_location)

      client.expect(:post, instance_location, [location,
                                               {:installation => installation_location,
                                                :name => 'test-instance',
                                                key => value},
                                               'locator-group-instance'])

      assert_equal(instance_location, LocatorInstances.new(location, client).create(installation, 'test-instance', {key => value}).location)
    end

    def test_instance
      location = 'https://localhost:8443/sqlfire/v1/groups/2/locator-instances/4/'

      client = StubClient.new

      instance = LocatorInstance.new(location, client)

      assert_equal('example', instance.name)
      assert_equal(true, instance.run_netserver)
      assert_equal(['-Da=alpha'], instance.jvm_options)
      assert_equal('bind.address', instance.bind_address)
      assert_equal('client.bind.address', instance.client_bind_address)
      assert_equal(1234, instance.client_port)
      assert_equal('peer.discovery.address', instance.peer_discovery_address)
      assert_equal(2345, instance.peer_discovery_port)
      assert_equal('256M', instance.initial_heap)
      assert_equal('512M', instance.max_heap)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/2/', instance.group.location)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/2/installations/3/', instance.installation.location)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/2/locator-instances/4/configurations/live/', instance.live_configurations.location)
      assert_equal(2, instance.node_instances.size)
      assert_equal('https://localhost:8443/sqlfire/v1/nodes/1/locator-instances/6/', instance.node_instances[0].location)
      assert_equal('https://localhost:8443/sqlfire/v1/nodes/0/locator-instances/5/', instance.node_instances[1].location)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/2/locator-instances/4/configurations/pending/', instance.pending_configurations.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/7/', instance.security.location)

      assert_equal('STOPPED', instance.state)

      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/groups/2/locator-instances/4/state/', {:status => 'STARTED', :serial => false}])
      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/groups/2/locator-instances/4/state/', {:status => 'STOPPED', :serial => false}])
      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/groups/2/locator-instances/4/state/', {:status => 'STARTED', :serial => true}])
      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/groups/2/locator-instances/4/state/', {:status => 'STOPPED', :serial => true}])

      instance.start
      instance.stop
      instance.start(true)
      instance.stop(true)

      client.verify
    end

    def test_update_with_installation
      client = StubClient.new
      installation = create_mock_with_location('https://localhost:8443/sqlfire/v1/groups/1/installations/3/')
      instance = LocatorInstance.new('https://localhost:8443/sqlfire/v1/groups/1/locator-instances/2/', client)

      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/groups/1/locator-instances/2/',
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

    def test_update_with_initial_heap
      do_test_update 'initial-heap', '1024M'
    end

    def test_update_with_jvm_options
      do_test_update 'jvm-options', ['-Da=alpha']
    end

    def test_update_with_max_heap
      do_test_update 'max-heap', '2048M'
    end

    def test_update_with_peer_discovery_address
      do_test_update 'peer-discovery-address', 'peer.discovery.address'
    end

    def test_update_with_peer_discovery_port
      do_test_update 'peer-discovery-port', 1234
    end

    def test_run_netserver
      do_test_update 'run-netserver', false
    end

    def do_test_update key, value
      client = StubClient.new
      installation = create_mock_with_location('https://localhost:8443/sqlfire/v1/groups/1/installations/3/')
      instance = LocatorInstance.new('https://localhost:8443/sqlfire/v1/groups/1/locator-instances/2/', client)

      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/groups/1/locator-instances/2/',
                                 {key => value}])

      instance.update({key => value})

      client.verify
    end

    def test_delete
      client = StubClient.new
      instance_location = 'https://localhost:8443/sqlfire/v1/groups/2/locator-instances/4/'
      client.expect(:delete, nil, [instance_location])
      LocatorInstance.new(instance_location, client).delete
      client.verify
    end

  end

end
