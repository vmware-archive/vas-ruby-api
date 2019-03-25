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

  # Used to enumerate revisions of a node application
  class NodeRevisions < Shared::Collection
    
    # @private
    def initialize(location, client)
      super(location, client, 'revisions', NodeRevision)
    end
    
  end

  # A revision of a node application
  class NodeRevision < Shared::StateResource

    # @return [String] the revision's version
    attr_reader :version

    # @private
    def initialize(location, client)
      super(location, client)

      @application_location = Util::LinkUtils.get_link_href(details, 'node-application')
      @group_revision_location = Util::LinkUtils.get_link_href(details, 'group-revision')

      @version = details['version']
    end

    # @return [NodeApplication] the revision's application
    def application
      @application ||= NodeApplication.new(@application_location, client)
    end

    # @return [Revision] the group revision that this node revision is a member of
    def group_revision
      @group_revision ||= Revision.new(@group_revision_location, client)
    end

    # @return [String] a string representation of the node revision
    def to_s
      "#<#{self.class} version='#@version'>"
    end

  end

end