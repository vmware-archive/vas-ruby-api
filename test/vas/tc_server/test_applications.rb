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
  class TestApplications < VasTestCase
  
    def test_list
      applications = Applications.new(
          'https://localhost:8443/tc-server/v1/groups/1/instances/2/applications/',
          StubClient.new)
      assert_count(2, applications)
      assert_equal('https://localhost:8443/vfabric/v1/security/4/', applications.security.location)
    end
  
    def test_create
      location = 'https://localhost:8443/tc-server/v1/groups/1/instances/2/applications/'
      application_location = 'https://localhost:8443/tc-server/v1/groups/1/instances/2/applications/3/'
  
      client = StubClient.new
      client.expect(:post, application_location, [location, { :name => 'My App', 'context-path' => '/myapp', :service => 'Catalina', :host => 'localhost' }, 'group-application'])
  
      assert_equal(application_location, Applications.new(location, client).create('My App', '/myapp', 'Catalina', 'localhost').location)
    end
  
    def test_application
      application = Application.new('https://localhost:8443/tc-server/v1/groups/2/instances/3/applications/6/', StubClient.new)
  
      assert_equal('Example', application.name)
      assert_equal('/example', application.context_path)
      assert_equal('Catalina', application.service)
      assert_equal('localhost', application.host)
      assert_equal('https://localhost:8443/tc-server/v1/groups/2/instances/3/applications/6/revisions/', application.revisions.location)
      assert_equal('https://localhost:8443/tc-server/v1/groups/2/instances/3/', application.instance.location)
      assert_equal(2, application.node_applications.size)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/1/instances/5/applications/8/', application.node_applications[0].location)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/0/instances/4/applications/7/', application.node_applications[1].location)
    end

    def test_delete
      client = StubClient.new
      application_location = 'https://localhost:8443/tc-server/v1/groups/1/instances/2/applications/3/'
      client.expect(:delete, nil, [application_location])
      Application.new(application_location, client).delete
      client.verify
    end
  
  end
end
