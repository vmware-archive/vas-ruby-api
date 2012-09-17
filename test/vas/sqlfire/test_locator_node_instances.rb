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

  class TestLocatorNodeInstances < VasTestCase
  
    def test_list
      instances = LocatorNodeInstances.new(
          'https://localhost:8443/sqlfire/v1/nodes/1/locator-instances/',
          StubClient.new)
      assert_count(2, instances)
      assert_equal('https://localhost:8443/vfabric/v1/security/3/', instances.security.location)
    end
  
    def test_instance
      location = 'https://localhost:8443/sqlfire/v1/nodes/1/locator-instances/2/'

      client = StubClient.new
        
      instance = LocatorNodeInstance.new(location, client)
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
      assert_equal('https://localhost:8443/sqlfire/v1/nodes/0/', instance.node.location)
      assert_equal('https://localhost:8443/sqlfire/v1/groups/1/locator-instances/2/', instance.group_instance.location)
      assert_equal('https://localhost:8443/sqlfire/v1/nodes/0/locator-instances/3/logs/', instance.logs.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/4/', instance.security.location)

      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/nodes/0/locator-instances/3/state/', { :status => 'STARTED'}])
      client.expect(:post, nil, ['https://localhost:8443/sqlfire/v1/nodes/0/locator-instances/3/state/', { :status => 'STOPPED'}])

      instance.start
      instance.stop

      client.verify
    end

  end

end
