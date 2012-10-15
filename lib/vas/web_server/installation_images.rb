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


module WebServer

  # Used to enumerate, create, and delete Web Server installation images.
  class InstallationImages < Shared::InstallationImages

    # @private
    def initialize(location, client)
      super(location, client, InstallationImage)
    end

    # Creates an installation image by uploading a file to the server and assigning it a version, architecture,
    # and operating system
    #
    # @param path the path of the file to upload
    # @param version [String] the installation image's version
    # @param architecture [String] the installation image's architecture
    # @param operating_system [String] the installation image's operating system
    #
    # @return [InstallationImage] the new installation image
    def create(path, version, architecture, operating_system)
      create_image(path, { :version => version,
                           :architecture => architecture,
                           'operating-system' => operating_system })
    end

  end
  
  # A Web Server installation image
  class InstallationImage < Shared::InstallationImage

    # @private
    def initialize(location, client)
      super(location, client, Installation)
    end

  end

end