#--
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
#++

module Gemfire
  
  class TestDiskStores < VasTestCase
  
    def test_list
      disk_stores = DiskStores.new(
          'https://localhost:8443/gemfire/v1/nodes/1/cache-server-instances/2/disk-stores/',
          StubClient.new)
      assert_count(2, disk_stores)
      assert_equal('https://localhost:8443/vfabric/v1/security/6/', disk_stores.security.location)
    end
  
    def test_disk_store
      client = StubClient.new
      disk_store = DiskStore.new('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/disk-stores/4/', client)
  
      assert_equal('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/disk-stores/4/', disk_store.location)
      assert_equal('example.gfs', disk_store.name)
      assert_equal(17638, disk_store.size)
      assert_equal(1337872856, disk_store.last_modified)
      assert_equal('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/', disk_store.instance.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/5/', disk_store.security.location)
  
      content = ''
      disk_store.content { |chunk| content << chunk}
      assert_equal('somestreamedcontent', content)
    end

    def test_delete
      client = StubClient.new
      disk_stores = DiskStores.new(
          'https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/disk-stores/', client)

      location = 'https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/disk-stores/4/'
      client.expect(:delete, nil, [location])

      disk_stores.delete(DiskStores.new(location, client))

      client.verify
    end
  
  end
end
