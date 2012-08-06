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

  # Used to enumerate, create, and delete application revisions.
  class Revisions < Shared::MutableCollection
    
    def initialize(location, client) #:nodoc:
      super(location, client, "revisions", Revision)
    end

    # Creates a Revision by deploying the RevisionImage +revision_image+
    def create(revision_image)
      Revision.new(client.post(location, { :image => revision_image.location}, 'group-revision'), client)
    end
    
  end

  # A revision of an Application
  class Revision < Shared::StateResource

    # The Revision's version
    attr_reader :version

    # The Revision's application
    attr_reader :application
    
    def initialize(location, client) #:nodoc:
      super(location, client)
      
      @version = details['version']
      @revision_image_location = Util::LinkUtils.get_link_href(details, 'revision-image')
      @application = Application.new(Util::LinkUtils.get_link_href(details, 'group-application'), client)
    end

    # The revision image, if any, that was used to create the revision
    def revision_image
      if (!@revision_image_location.nil?)
        RevisionImage.new(@revision_image_location, client)
      end
    end

    # An array of the revision's individual node revisions
    def node_revisions
      node_revisions = []
      Util::LinkUtils.get_link_hrefs(client.get(location), 'node-revision').each {
          |node_revision_location| node_revisions << NodeRevision.new(node_revision_location, client)}
      node_revisions
    end
    
    def to_s #:nodoc:
      "#<#{self.class} version='#@version'>"
    end
  end

end