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

  # @abstract A configuration file in a node instance
  class NodeConfiguration < Shared::Resource

    # @return [String] the configuration's path
    attr_reader :path

    # @return [Integer] the configuration's size
    attr_reader :size

    # @return [LiveConfiguration] the node configuration's group configuration
    attr_reader :group_configuration

    # @return [NodeInstance] the node instance that owns the configuration
    attr_reader :instance

    private
    
    attr_reader :content_location
    
    public

    # @private
    def initialize(location, client, instance_type, instance_class, group_configuration_class)
      super(location, client)

      @path = details["path"]
      @size = details["size"]
      @group_configuration = group_configuration_class.new(
          Util::LinkUtils.get_link_href(details, 'group-live-configuration'), client)
      @instance = instance_class.new(Util::LinkUtils.get_link_href(details, instance_type), client)
      @content_location = Util::LinkUtils.get_link_href(details, "content")
    end

    # Retrieves the configuration's content and passes it to the block
    #
    # @yield [chunk] a chunk of the configuration's content
    #
    # @return [void]
    def content(&block)
      client.get_stream(@content_location, &block)
    end

    # @return [String] a string representation of the configuration
    def to_s
      "#<#{self.class} name='#@path' size=#@size>"
    end

  end
end