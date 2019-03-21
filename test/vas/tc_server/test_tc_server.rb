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


module TcServer
  
  class TestTcServer < VasTestCase
  
    def test_locations
  
      tc_server = TcServer.new('https://localhost:8443/tc-server/v1/', StubClient.new)
      
      assert_equal("https://localhost:8443/tc-server/v1/groups/", tc_server.groups.location)
      assert_equal("https://localhost:8443/tc-server/v1/installation-images/", tc_server.installation_images.location)
      assert_equal("https://localhost:8443/tc-server/v1/nodes/", tc_server.nodes.location)
      assert_equal("https://localhost:8443/tc-server/v1/revision-images/", tc_server.revision_images.location)
      assert_equal("https://localhost:8443/tc-server/v1/template-images/", tc_server.template_images.location)
    end
  
  end
  
end