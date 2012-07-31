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

    def initialize(location, client)
      super(location, client, 'statistics', Statistic)
    end

  end

  # A statistic of a cache server
  class Statistic < Shared::Resource

    # The last modified time of the disk store
    attr_reader :last_modified

    # The path of statistic
    attr_reader :path

    # The size of the statistic
    attr_reader :size

    # The statistic's cache server node instance
    attr_reader :instance

    def initialize(location, client)
      super(location, client)

      @last_modified = details['last-modified']
      @path = details['path']
      @size = details['size']

      @instance = CacheServerNodeInstance.new(Util::LinkUtils.get_link_href(details, 'cache-server-node-instance'), client)
      @content_location = Util::LinkUtils.get_link_href(details, 'content')
    end

    # Retrieves the statistic's content and passes it to the +block+
    def content(&block)
      client.get_stream(@content_location, &block)
    end

    def to_s
      "#<#{self.class} path='#@path'>"
    end

  end

end