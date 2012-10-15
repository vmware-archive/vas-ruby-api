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


module Gemfire

  # Used to enumerate, create, and delete GemFire application code images.
  class ApplicationCodeImages < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, 'application-code-images', ApplicationCodeImage)
    end
    
    # Creates a new application code image by uploading a file and assigning it a name and version
    #
    # @param path [String] the path of the file to upload
    # @param name [String] the name of the application code
    # @param version [String] the version of the application code
    #
    # @return [ApplicationCodeImage] the new application code image
    def create(path, name, version)
      create_image(path, { :name => name, :version => version })
    end
    
  end
  
  # An application code image
  class ApplicationCodeImage < Shared::Resource
    
    include Shared::Deletable

    # @return [String] the application code image's name
    attr_reader :name

    # @return [String] the application code image's version
    attr_reader :version

    # @return [String] the application code image's size
    attr_reader :size

    # @private
    def initialize(location, client)
      super(location, client)

      @name = details['name']
      @version = details['version']
      @size = details['size']
    end

    # @return [ApplicationCode[]] the live application code that has been created from this application code image
    def live_application_code
      @live_application_codes ||= create_resources_from_links('live-application-code', ApplicationCode)
    end

    # @return [ApplicationCode[]] the pending application code that has been created from this application code image
    def pending_application_code
      @pending_application_codes ||= create_resources_from_links('pending-application-code', ApplicationCode)
    end

    def reload
      super
      @live_application_codes = nil
      @pending_application_codes = nil
    end

    # @return [String] a string representation of the application code image
    def to_s
      "#<#{self.class} name='#@name' version='#@version' size='#@size'>"
    end

  end

end