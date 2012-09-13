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

  class TestLocatorLiveConfigurations < VasTestCase

    def test_list
      configurations = LocatorLiveConfigurations.new(
          'https://localhost:8443/gemfire/v1/groups/1/locator-instances/2/configurations/live/',
          StubClient.new)
      assert_count(1, configurations)
      assert_equal('https://localhost:8443/vfabric/v1/security/3/', configurations.security.location)
    end
  
    def test_live_configuration
      location = 'https://localhost:8443/gemfire/v1/groups/1/locator-instances/2/configurations/live/3/'
  
      live_configuration = LocatorLiveConfiguration.new(location, StubClient.new)

      assert_equal('gemfire.properties', live_configuration.path)
      assert_equal(10537, live_configuration.size)

      assert_equal('https://localhost:8443/gemfire/v1/groups/0/locator-instances/1/', live_configuration.instance.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/3/', live_configuration.security.location)
      assert_equal('https://localhost:8443/gemfire/v1/groups/1/locator-instances/2/configurations/live/3/', live_configuration.location)

      content = ''
  
      live_configuration.content { |chunk| content << chunk}
  
      assert_equal('somestreamedcontent', content)
    end
  
  end
end
