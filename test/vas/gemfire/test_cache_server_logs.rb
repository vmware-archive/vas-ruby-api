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

  class TestCacheServerLogs < VasTestCase
  
    def test_list
      logs = CacheServerLogs.new(
          'https://localhost:8443/gemfire/v1/nodes/1/cache-server-instances/2/logs/',
          StubClient.new)
      assert_count(2, logs)
      assert_equal('https://localhost:8443/vfabric/v1/security/6/', logs.security.location)
    end
  
    def test_log
      location = 'https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/logs/4/'
        
      log = CacheServerLog.new(location, StubClient.new)
  
      assert_equal('example.log', log.name)
      assert_equal(17638, log.size)
      assert_equal(1337872856, log.last_modified)

      assert_equal('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/', log.instance.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/5/', log.security.location)
    end

    def test_content
      log = CacheServerLog.new('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/logs/4/', StubClient.new)
      content = ""
      log.content { |chunk| content << chunk}
      assert_equal('somestreamedcontent', content)
    end


    def test_content_with_start_line
      log = CacheServerLog.new('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/logs/4/', StubClient.new)
      content = ""
      log.content({:start_line => 2}) { |chunk| content << chunk}
      assert_equal('content', content)
    end

    def test_content_with_end_line
      log = CacheServerLog.new('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/logs/4/', StubClient.new)
      content = ""
      log.content({:end_line => 1}) { |chunk| content << chunk}
      assert_equal('somestreamed', content)
    end

    def test_delete
      client = StubClient.new
      logs = CacheServerLogs.new('https://localhost:8443/gemfire/v1/nodes/1/cache-server-instances/2/logs/', client)
      location = 'https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/logs/4/'
      client.expect(:delete, nil, [location])

      logs.delete(CacheServerLog.new(location, client))

      client.verify
    end

  end

end
