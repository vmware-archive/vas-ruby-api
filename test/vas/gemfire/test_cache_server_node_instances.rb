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

  class TestCacheServerNodeInstances < VasTestCase
  
    def test_list
      instances = CacheServerNodeInstances.new(
          'https://localhost:8443/gemfire/v1/nodes/1/cache-server-instances/',
          StubClient.new)
      assert_count(2, instances)
      assert_equal('https://localhost:8443/vfabric/v1/security/3/', instances.security.location)
    end
  
    def test_instance
      location = 'https://localhost:8443/gemfire/v1/nodes/1/cache-server-instances/2/'

      client = StubClient.new
        
      instance = CacheServerNodeInstance.new(location, client)
  
      assert_equal('example', instance.name)

      assert_equal('https://localhost:8443/gemfire/v1/groups/1/cache-server-instances/2/', instance.group_instance.location)
      assert_equal('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/disk-stores/', instance.disk_stores.location)
      assert_equal('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/logs/', instance.logs.location)
      assert_equal('https://localhost:8443/gemfire/v1/nodes/0/', instance.node.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/4/', instance.security.location)
      assert_equal('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/statistics/', instance.statistics.location)

      client.expect(:post, nil, ['https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/state/', { :status => 'STARTED', :rebalance => false}])
      client.expect(:post, nil, ['https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/state/', { :status => 'STOPPED'}])
      client.expect(:post, nil, ['https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/state/', { :status => 'STARTED', :rebalance => true}])

      instance.start
      instance.stop
      instance.start(true)

      client.verify
    end

  end

end
