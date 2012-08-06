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

module Shared

  class Configuration < Shared::Resource

    # The path of the configuration
    attr_reader :path

    # The size of the configuration
    attr_reader :size

    private
    attr_reader :content_location

    def initialize(location, client, instance_type, instance_class) #:nodoc:
      super(location, client)

      @path = details["path"]
      @size = details["size"]

      @instance_location = Util::LinkUtils.get_link_href(details, instance_type)
      @content_location = Util::LinkUtils.get_link_href(details, "content")

      @instance_class = instance_class
    end

    public
    # Retrieves the configuration's content and passes it to the block
    def content(&block)
      client.get_stream(@content_location, &block)
    end

    # The instance that owns the configuration
    def instance
      @instance_class.new(@instance_location, client)
    end

    def to_s #:nodoc:
      "#<#{self.class} name='#@path' size=#@size>"
    end

  end
end