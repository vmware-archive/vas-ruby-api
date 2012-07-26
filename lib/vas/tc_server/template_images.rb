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

  # Used to enumerate, create, and delete tc Server template images.
  class TemplateImages < Shared::Collection

    def initialize(location, client) #:nodoc:
      super(location, client, "template-images", TemplateImage)
    end
    
    # Creates a TemplateImage named +name+ with the version +version+ by uploading the file at the given +path+
    def create(path, name, version)
      TemplateImage.new(client.post_image(location, path, { :name => name, :version => version }), client)
    end
    
  end
  
  # A template image
  class TemplateImage < Shared::Resource

    # The template image's name
    attr_reader :name

    # The template image's version
    attr_reader :version

    def initialize(location, client) #:nodoc:
      super(location, client)

      @name = details["name"]
      @version = details["version"]
    end

    # The Template s that have been created from this TemplateImage
    def templates
      templates = []
      Util::LinkUtils.get_link_hrefs(client.get(location), "template").each { |template_location| templates << Template.new(template_location, client)}
      templates
    end

    def to_s #:nodoc:
      "#<#{self.class} name='#@name' version='#@version'>"
    end

  end

end