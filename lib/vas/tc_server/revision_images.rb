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

    def initialize(location, client) #:nodoc:
      super(location, client, "revision-images")
    end
    
    # Creates a RevisionImage named +name+ with the version +version+ by uploading the WAR file at the given +path+
    def create(path, name, version)
      RevisionImage.new(client.post_image(location, path, { :name => name, :version => version }), client)
    end
    
    private
    def create_entry(json)
      RevisionImage.new(Util::LinkUtils.get_self_link_href(json), client)
    end
    
  end
  
  # A revision image, i.e. a WAR file
  class RevisionImage < Shared::Resource

    # The revision image's name
    attr_reader :name

    # The revision image's version
    attr_reader :version

    def initialize(location, client) #:nodoc:
      super(location, client)

      @name = details["name"]
      @version = details["version"]
    end

    # The Revision s that have been created from this RevisionImage
    def revisions
      revisions = []
      Util::LinkUtils.get_link_hrefs(client.get(location), "group-revision").each { |revision_location| revisions << Revision.new(revision_location, client)}
      revisions
    end

    def to_s #:nodoc:
      "#<#{self.class} name='#@name' version='#@version'>"
    end

  end

end