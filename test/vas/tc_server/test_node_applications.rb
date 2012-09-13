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
  class TestNodeApplications < VasTestCase
  
    def test_list
      applications = NodeApplications.new(
          'https://localhost:8443/tc-server/v1/nodes/1/instances/2/applications/',
          StubClient.new)
      assert_count(2, applications)
      assert_equal('https://localhost:8443/vfabric/v1/security/8/', applications.security.location)
    end
  
    def test_application
      application = NodeApplication.new('https://localhost:8443/tc-server/v1/nodes/0/instances/3/applications/5/', StubClient.new)
  
      assert_equal('Example', application.name)
      assert_equal('/example', application.context_path)
      assert_equal('Catalina', application.service)
      assert_equal('localhost', application.host)
      assert_equal('https://localhost:8443/tc-server/v1/groups/1/instances/2/applications/4/', application.group_application.location)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/0/instances/3/', application.instance.location)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/0/instances/3/applications/5/revisions/', application.revisions.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/6/', application.security.location)
    end
  
  end
end
