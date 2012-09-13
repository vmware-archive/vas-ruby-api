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

  # Used to enumerate and delete a cache server's statistics.
  class Statistics < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, 'statistics', Statistic)
    end

  end

  # A statistic of a cache server
  class Statistic < Shared::Resource

    # @return [String] the path of statistic
    attr_reader :path

    # @return [CacheServerNodeInstance] The statistic's cache server node instance
    attr_reader :instance

    # @private
    def initialize(location, client)
      super(location, client)

      @path = details['path']

      @instance = CacheServerNodeInstance.new(Util::LinkUtils.get_link_href(details, 'cache-server-node-instance'), client)
      @content_location = Util::LinkUtils.get_link_href(details, 'content')
    end
    
    # @return [Integer] the size of the statistic
    def size
      client.get(location)['size']
    end

    # @return [Integer] the last modified stamp of the statistic
    def last_modified
      client.get(location)['last-modified']
    end

    # Retrieves the statistic's content
    #
    # @yield [chunk] a chunk of the statistic's content
    #
    # @return [void]
    def content(&block)
      client.get_stream(@content_location, &block)
    end

    # @return [String] a string representation of the statistic
    def to_s
      "#<#{self.class} path='#@path'>"
    end

  end

end