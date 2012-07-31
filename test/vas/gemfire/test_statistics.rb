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
  
  class TestStatistics < VasTestCase
  
    def test_list
      statistics = Statistics.new(
          'https://localhost:8443/gemfire/v1/nodes/1/cache-server-instances/2/statistics/',
          StubClient.new)
      assert_count(2, statistics)
      assert_equal('https://localhost:8443/vfabric/v1/security/6/', statistics.security.location)
    end
  
    def test_statistic
      client = StubClient.new
      statistic = Statistic.new('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/statistics/4/', client)
  
      assert_equal('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/statistics/4/', statistic.location)
      assert_equal('example.statistic', statistic.path)
      assert_equal(17638, statistic.size)
      assert_equal(1337872856, statistic.last_modified)
      assert_equal('https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/', statistic.instance.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/5/', statistic.security.location)
  
      content = ''
      statistic.content { |chunk| content << chunk}
      assert_equal('somestreamedcontent', content)
    end

    def test_delete
      client = StubClient.new
      statistics = Statistics.new(
          'https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/statistics/', client)

      location = 'https://localhost:8443/gemfire/v1/nodes/0/cache-server-instances/3/statistics/4/'
      client.expect(:delete, nil, [location])

      statistics.delete(Statistics.new(location, client))

      client.verify
    end
  
  end
end
