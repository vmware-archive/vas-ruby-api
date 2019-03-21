# vFabric Administration Server Ruby API
# Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


module WebServer

  class TestNodeLiveConfigurations < VasTestCase

    def test_list
      configurations = NodeLiveConfigurations.new(
          'https://localhost:8443/web-server/v1/nodes/1/instances/2/configurations/live/',
          StubClient.new)
      assert_count(2, configurations)
      assert_equal('https://localhost:8443/vfabric/v1/security/6/', configurations.security.location)
    end
  
    def test_node_live_configuration
      location = 'https://localhost:8443/web-server/v1/nodes/1/instances/2/configurations/live/3/'
  
      node_live_configuration = NodeLiveConfiguration.new(location, StubClient.new)

      assert_equal('conf/httpd.conf', node_live_configuration.path)
      assert_equal(3412, node_live_configuration.size)

      assert_equal('https://localhost:8443/web-server/v1/nodes/0/instances/3/', node_live_configuration.instance.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/6/', node_live_configuration.security.location)
      assert_equal('https://localhost:8443/web-server/v1/nodes/1/instances/2/configurations/live/3/', node_live_configuration.location)
      assert_equal('https://localhost:8443/web-server/v1/groups/1/instances/2/configurations/live/4/', node_live_configuration.group_configuration.location)

      content = ''
  
      node_live_configuration.content { |chunk| content << chunk}
  
      assert_equal('somestreamedcontent', content)
    end
  
  end
end
