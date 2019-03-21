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
      super({ :image => revision_image.location}, 'group-revision')
    end
    
  end

  # A revision of an application
  class Revision < Shared::StateResource

    include Shared::Deletable

    # @return [String] the revision's version
    attr_reader :version

    # @private
    def initialize(location, client)
      super(location, client)

      @version = details['version']
      @application_location = Util::LinkUtils.get_link_href(details, 'group-application')
      @revision_image_location = Util::LinkUtils.get_link_href(details, 'revision-image')
    end

    # @return [NodeRevision[]] the revision's node revisions
    def node_revisions
      @node_revisions ||= create_resources_from_links('node-revision', NodeRevision)
    end

    # @return [Application] the revision's application
    def application
      @application ||= Application.new(@application_location, client)
    end

    # @return [RevisionImage] the revision image, if any, that was used to create the revision
    def revision_image
      if @revision_image.nil?
        @revision_image = RevisionImage.new(@revision_image_location, client) unless @revision_image_location.nil?
      end
      @revision_image
    end
    
    # @return [String] a string representation of the revision
    def to_s
      "#<#{self.class} version='#@version'>"
    end
  end

end