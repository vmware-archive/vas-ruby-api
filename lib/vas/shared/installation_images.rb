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

module Shared

  class InstallationImages < MutableCollection

    def initialize(location, client, installation_image_class) #:nodoc:
      super(location, client, "installation-images", installation_image_class)
    end

    # Creates an installation image with the version +version+ by uploading the file at the given +path+.
    def create(path, version)
      entry_class.new(client.post_image(location, path, { :version => version }), client)
    end

  end

  class InstallationImage < Resource
    
    # The installation image's version
    attr_reader :version

    # The installation image's size
    attr_reader :size

    def initialize(location, client, installation_class) #:nodoc:
      super(location, client)
      @version = details["version"]
      @size = details["size"]
      @installation_class = installation_class
    end

    def installations
      installations = []
      Util::LinkUtils.get_link_hrefs(client.get(location), "installation").each { |installation_location|
        installations << @installation_class.new(installation_location, client)
      }
      installations
    end

    def to_s #:nodoc:
      "#<#{self.class} version='#@version'>"
    end

  end

end