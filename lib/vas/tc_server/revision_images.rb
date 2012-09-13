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

  # Used to enumerate, create, and delete tc Server revision images.
  class RevisionImages < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, "revision-images", RevisionImage)
    end
    
    # Creates a new revision image by uploading a war file to the server
    #
    # @param path [String] the path of the WAR file
    # @param name [String] the name of the revision image
    # @param version [String] the version of the revision image
    #
    # @return [RevisionImage] the new revision image
    def create(path, name, version)
      RevisionImage.new(client.post_image(location, path, { :name => name, :version => version }), client)
    end
    
  end
  
  # A revision image, i.e. a WAR file
  class RevisionImage < Shared::Resource

    # @return [String] the revision image's name
    attr_reader :name

    # @return [String] the revision image's version
    attr_reader :version

    # @return [Integer] the revision image's size
    attr_reader :size

    # @private
    def initialize(location, client)
      super(location, client)

      @name = details["name"]
      @version = details["version"]
      @size = details['size']
    end

    # @return [Revision[]] the revisions that have been created from this revision image
    def revisions
      revisions = []
      Util::LinkUtils.get_link_hrefs(client.get(location), "group-revision").each { |revision_location| revisions << Revision.new(revision_location, client)}
      revisions
    end

    # @return [String] a string representation of the revision image
    def to_s
      "#<#{self.class} name='#@name' version='#@version' size='#@size'>"
    end

  end

end