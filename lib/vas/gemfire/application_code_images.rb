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

module Gemfire

  # Used to enumerate, create, and delete GemFire application code images.
  class ApplicationCodeImages < Shared::MutableCollection

    def initialize(location, client) #:nodoc:
      super(location, client, "application-code-images", ApplicationCodeImage)
    end
    
    # Creates an application code image named +name+ with the version +version+ by uploading the file at the given +path+
    def create(path, name, version)
      ApplicationCodeImage.new(client.post_image(location, path, { :name => name, :version => version }), client)
    end
    
  end
  
  # An application code image
  class ApplicationCodeImage < Shared::Resource

    # The application code image's name
    attr_reader :name

    # The application code image's version
    attr_reader :version

    # The application code image's size
    attr_reader :size

    def initialize(location, client) #:nodoc:
      super(location, client)

      @name = details['name']
      @version = details['version']
      @size = details['size']
    end

    # An array of the live application code that has been created from this application code image
    def live_application_code
      application_codes = []
      Util::LinkUtils.get_link_hrefs(client.get(location), "live-application-code").each {
          |application_code_location| application_codes << ApplicationCode.new(application_code_location, client)}
      application_codes
    end

    # An array of the pending application code that has been created from this application code image
    def pending_application_code
      application_codes = []
      Util::LinkUtils.get_link_hrefs(client.get(location), "pending-application-code").each {
          |application_code_location| application_codes << ApplicationCode.new(application_code_location, client)}
      application_codes
    end

    def to_s #:nodoc:
      "#<#{self.class} name='#@name' version='#@version'>"
    end

  end

end