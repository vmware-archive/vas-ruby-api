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
  class TestNodeInstances < VasTestCase
  
    def test_list
      instances = NodeInstances.new(
          'https://localhost:8443/tc-server/v1/nodes/1/instances/',
          StubClient.new)
      assert_count(2, instances)
      assert_equal('https://localhost:8443/vfabric/v1/security/3/', instances.security.location)
    end
  
    def test_instance
      location = 'https://localhost:8443/tc-server/v1/nodes/1/instances/2/'

      client = StubClient.new
        
      instance = NodeInstance.new(location, client)
  
      assert_equal('example', instance.name)
      assert_equal({ 'Catalina' => { 'hosts' => ['localhost']}}, instance.services)
      assert_equal('SEPARATE', instance.layout)
      assert_equal('7.0.21.A.RELEASE', instance.runtime_version)
      assert_equal('https://localhost:8443/tc-server/v1/groups/1/instances/2/', instance.group_instance.location)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/0/instances/3/logs/', instance.logs.location)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/0/', instance.node.location)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/0/instances/3/applications/', instance.applications.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/4/', instance.security.location)

      client.expect(:post, nil, ['https://localhost:8443/tc-server/v1/nodes/0/instances/3/state/', { :status => 'STARTED'}])
      client.expect(:post, nil, ['https://localhost:8443/tc-server/v1/nodes/0/instances/3/state/', { :status => 'STOPPED'}])

      instance.start
      instance.stop

      client.verify
    end
  end
end
