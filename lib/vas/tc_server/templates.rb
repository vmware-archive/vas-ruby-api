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

  # Used to enumerate, create, and delete tc Server templates.
  class Templates < Shared::Collection
    
    def initialize(location, client) #:nodoc:
      super(location, client, "templates")
    end
    
    # Creates a Template from the TemplateImage +template_image+
    def create(template_image)
      Template.new(client.post(location, { :image => template_image.location }, "template"), client)
    end
    
    private
    def create_entry(json)
      Template.new(Util::LinkUtils.get_self_link_href(json), client)
    end
    
  end
  
  # A tc Server template
  class Template < Shared::Resource

    # The template's version
    attr_reader :version
    
    # The template's name
    attr_reader :name

    def initialize(location, client) #:nodoc:
      super(location, client)

      @version = details["version"]
      @name = details["name"]
      @template_image_location = Util::LinkUtils.get_link_href(details, "template-image")
    end

    # The TemplateImage, if any, that this Template was created from
    def template_image
      if (!@template_image_location.nil?)
        TemplateImage.new(@template_image_location, client)
      end
    end
    
    def to_s #:nodoc:
      "#<#{self.class} name='#@name' version='#@version'>"
    end
    
  end
  
end