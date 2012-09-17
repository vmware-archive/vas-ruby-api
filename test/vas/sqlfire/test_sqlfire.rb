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
  
  class TestSqlfire < VasTestCase
  
    def test_locations
  
      sqlfire = Sqlfire.new('https://localhost:8443/sqlfire/v1/', StubClient.new)
      
      assert_equal("https://localhost:8443/sqlfire/v1/groups/", sqlfire.groups.location)
      assert_equal("https://localhost:8443/sqlfire/v1/installation-images/", sqlfire.installation_images.location)
      assert_equal("https://localhost:8443/sqlfire/v1/nodes/", sqlfire.nodes.location)
    end
  
  end
  
end