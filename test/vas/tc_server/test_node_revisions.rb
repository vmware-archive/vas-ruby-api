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

  class TestNodeRevisions < VasTestCase

    def test_list
      revisions = NodeRevisions.new(
          'https://localhost:8443/tc-server/v1/nodes/1/instances/2/applications/3/revisions/',
          StubClient.new)
      assert_count(2, revisions)
      assert_equal('https://localhost:8443/vfabric/v1/security/10/', revisions.security.location)
    end

    def test_revision

      client = StubClient.new

      revision = NodeRevision.new(
          'https://localhost:8443/tc-server/v1/nodes/0/instances/3/applications/5/revisions/7/', client)

      assert_equal('1.0.0', revision.version)

      assert_equal('https://localhost:8443/tc-server/v1/groups/1/instances/2/applications/4/revisions/6/', revision.group_revision.location)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/0/instances/3/applications/5/', revision.application.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/8/', revision.security.location)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/0/instances/3/applications/5/revisions/7/', revision.location)

      assert_equal('STOPPED', revision.state)

      client.expect(:post, nil, [
          'https://localhost:8443/tc-server/v1/nodes/0/instances/3/applications/5/revisions/7/state/',
          {:status => 'STARTED'}
      ])
      client.expect(:post, nil, [
          'https://localhost:8443/tc-server/v1/nodes/0/instances/3/applications/5/revisions/7/state/',
          {:status => 'STOPPED'}
      ])

      revision.start
      revision.stop

      client.verify

    end

  end

end