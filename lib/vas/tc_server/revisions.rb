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

  # Used to enumerate, create, and delete application revisions.
  class Revisions < Shared::MutableCollection
    
    # @private
    def initialize(location, client)
      super(location, client, "revisions", Revision)
    end

    # Creates a revision by deploying the revision image
    #
    # @param revision_image [RevisionImage] the revision image to deploy
    #
    # @return [Revision] the new revision
    def create(revision_image)
      Revision.new(client.post(location, { :image => revision_image.location}, 'group-revision'), client)
    end
    
  end

  # A revision of an application
  class Revision < Shared::StateResource

    # @return [String] the revision's version
    attr_reader :version

    # @return [Application] the revision's application
    attr_reader :application
    
    # @return [RevisionImage] the revision image, if any, that was used to create the revision
    attr_reader :revision_image
    
    # @private
    def initialize(location, client)
      super(location, client)
      
      @version = details['version']
      @application = Application.new(Util::LinkUtils.get_link_href(details, 'group-application'), client)
      
      revision_image_location = Util::LinkUtils.get_link_href(details, 'revision-image')
      @revision_image = RevisionImage.new(revision_image_location, client) unless revision_image_location.nil?
    end

    # @return [NodeRevision[]] the revision's node revisions
    def node_revisions
      node_revisions = []
      Util::LinkUtils.get_link_hrefs(client.get(location), 'node-revision').each {
          |node_revision_location| node_revisions << NodeRevision.new(node_revision_location, client)}
      node_revisions
    end
    
    # @return [String] a string representation of the revision
    def to_s
      "#<#{self.class} version='#@version'>"
    end
  end

end