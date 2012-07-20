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

  # Used to enumerate, create, and delete tc Server installation images.
  class InstallationImages < Shared::MutableCollection

    def initialize(location, client) #:nodoc:
      super(location, client, "installation-images")
    end

    # Creates an InstallationImage with the version +version+ by uploading the file at the given +path+.
    def create(path, version)
      InstallationImage.new(client.post_image(location, path, { :version => version }), client)
    end

    private
    def create_entry(json)
      InstallationImage.new(Util::LinkUtils.get_self_link_href(json), client)
    end

  end
  
  # A tc Server installation image
  class InstallationImage < Shared::Resource
    
    # The installation image's version
    attr_reader :version

    def initialize(location, client) #:nodoc:
      super(location, client)

      @version = details["version"]
    end

    # The Installation s that have been created from this InstallationImage
    def installations
      installations = []
      Util::LinkUtils.get_link_hrefs(client.get(location), "installation").each { |installation_location|
        installations << Installation.new(installation_location, client)
      }
      installations
    end

    def to_s #:nodoc:
      "#<#{self.class} version='#@version'>"
    end

  end

end