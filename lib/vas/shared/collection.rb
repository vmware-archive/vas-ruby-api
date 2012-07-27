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
  
  class Collection < Shared::Resource

    private
    attr_reader :entry_class

    def initialize(location, client, type, entry_class) #:nodoc:
      super(location, client)
      @type = type
      @entry_class = entry_class
    end

    public

    # Gets the items in the collection from the server. Calls the block once for each item.
    def each # :yields: item
      items = client.get(location)[@type]

      if (!items.nil?)
        client.get(location)[@type].each { |item|
          yield entry_class.new(Util::LinkUtils.get_self_link_href(item), client)
        }
      end
    end
  
  end
  
end