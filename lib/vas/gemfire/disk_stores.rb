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

  # Provides access to a cache server node instance's disk stores
  class DiskStores < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, 'disk-stores', DiskStore)
    end

  end

  # A disk store in a cache server node instance
  class DiskStore < Shared::Resource

    # @return [String] the name of the disk store
    attr_reader :name

    # @return [CacheServerNodeInstance] the disk store's cache server node instance
    attr_reader :instance

    # @private
    def initialize(location, client)
      super(location, client)

      @name = details['name']
      @instance = CacheServerNodeInstance.new(Util::LinkUtils.get_link_href(details, 'cache-server-node-instance'), client)
      @content_location = Util::LinkUtils.get_link_href(details, 'content')
    end

    # Retrieves the disk store's content
    #
    # @yield [chunk] a chunk of the disk store's content
    #
    # @return [void]
    def content(&block)
      client.get_stream(@content_location, &block)
    end
    
    # @return [Integer] the size of the disk store
    def size
      client.get(location)['size']
    end

    # @return [Integer] the last modified stamp of the disk store
    def last_modified
      client.get(location)['last-modified']
    end

    # @return [String] a string representation of the disk store
    def to_s
      "#<#{self.class} name='#@name'>"
    end

  end

end