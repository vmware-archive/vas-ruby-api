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

  class TestRevisions < VasTestCase

    def test_list
      revisions = Revisions.new(
          'https://localhost:8443/tc-server/v1/groups/1/instances/2/applications/3/revisions/',
          StubClient.new)
      assert_count(2, revisions)
      assert_equal('https://localhost:8443/vfabric/v1/security/7/', revisions.security.location)
    end

    def test_create
      location = 'https://localhost:8443/tc-server/v1/groups/1/instances/2/applications/3/revisions/'
      revision_image_location = 'https://localhost:8443/tc-server/v1/revision-images/1'

      client = StubClient.new

      revision_location = 'https://localhost:8443/tc-server/v1/groups/1/instances/2/applications/3/revisions/4/'

      revision_image = create_mock_with_location(revision_image_location)

      client.expect(:post, revision_location, [location, {:image => revision_image_location}, "group-revision"])

      assert_equal(revision_location, Revisions.new(location, client).create(revision_image).location)
    end

    def test_revision

      client = StubClient.new

      revision = Revision.new(
          'https://localhost:8443/tc-server/v1/groups/3/instances/4/applications/7/revisions/10/', client)

      assert_equal('1.0.0', revision.version)

      assert_equal('https://localhost:8443/tc-server/v1/groups/3/instances/4/applications/7/', revision.application.location)
      assert_equal(2, revision.node_revisions.size)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/1/instances/6/applications/9/revisions/12/', revision.node_revisions[0].location)
      assert_equal('https://localhost:8443/tc-server/v1/nodes/0/instances/5/applications/8/revisions/11/', revision.node_revisions[1].location)
      assert_equal('https://localhost:8443/tc-server/v1/revision-images/2/', revision.revision_image.location)
      assert_equal('https://localhost:8443/vfabric/v1/security/13/', revision.security.location)
      assert_equal('https://localhost:8443/tc-server/v1/groups/3/instances/4/applications/7/revisions/10/', revision.location)

      assert_equal('STOPPED', revision.state)

      client.expect(:post, nil, [
          'https://localhost:8443/tc-server/v1/groups/3/instances/4/applications/7/revisions/10/state/',
          {:status => 'STARTED'}
      ])
      client.expect(:post, nil, [
          'https://localhost:8443/tc-server/v1/groups/3/instances/4/applications/7/revisions/10/state/',
          {:status => 'STOPPED'}
      ])

      revision.start
      revision.stop

      client.verify

    end

    def test_delete
      client = StubClient.new
      revisions = Revisions.new(
          'https://localhost:8443/tc-server/v1/groups/1/instances/2/applications/3/revisions', client)
      revision_location = 'https://localhost:8443/tc-server/v1/groups/1/instances/2/applications/3/revisions/4/'
      client.expect(:delete, nil, [revision_location])
      revisions.delete(Revision.new(revision_location, client))
      client.verify
    end

  end

end