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

module TcServer

  class TestNodes < VasTestCase
  
    def test_list
      nodes = Nodes.new(
          "https://localhost:8443/tc-server/v1/nodes/",
          StubClient.new)
      assert_count(2, nodes)
      assert_equal('https://localhost:8443/vfabric/v1/security/2/', nodes.security.location)
    end
  
    def test_detail
      location = "https://localhost:8443/tc-server/v1/nodes/1/"
      client = StubClient.new

      node = Node.new(location, client)

      assert_equal(location, node.location)
      assert_equal([ "192.168.0.2", "127.0.0.1"], node.ip_addresses)
      assert_equal([ "example-host"], node.host_names)
      assert_equal("Linux", node.operating_system)
      assert_equal("x64", node.architecture)
      assert_equal("/opt/vmware/vfabric-administration-agent", node.agent_home)
      assert_equal({ "a" => "alpha" , "b" => "bravo" }, node.metadata)
      assert_equal("/usr/bin", node.java_home)

      assert_equal(2, node.groups.size)
      assert_equal('https://localhost:8443/tc-server/v1/groups/2/', node.groups[0].location)
      assert_equal('https://localhost:8443/tc-server/v1/groups/1/', node.groups[1].location)
      assert_equal('https://localhost:8443/vfabric/v1/security/3/', node.security.location)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/0/instances/', node.instances.location)

    end
  
  end

end
  