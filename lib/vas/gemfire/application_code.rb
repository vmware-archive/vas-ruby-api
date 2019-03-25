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


module Gemfire

  # Application code in a cache server instance
  class ApplicationCode < Shared::Resource

    # @return [String] the name of the application code
    attr_reader :name

    # @return [String] the version of the application code
    attr_reader :version

    # @private
    def initialize(location, client)
      super(location, client)

      @name = details['name']
      @version = details['version']

      @application_code_image_location = Util::LinkUtils.get_link_href(details, 'application-code-image')
      @instance_location = Util::LinkUtils.get_link_href(details, 'cache-server-group-instance')
    end

    # @return [ApplicationCodeImage] the image that was used to create the application code
    def application_code_image
      @application_code_image ||= ApplicationCodeImage.new(@application_code_image_location, client)
    end

    # @return [CacheServerInstance] the cache server instance that contains the application code
    def instance
      @instance ||= CacheServerInstance.new(@instance_location, client)
    end

    # @return [String] a string representation of the application code
    def to_s #:nodoc:
      "#<#{self.class} name='#@name' version=#@version>"
    end

  end

end
