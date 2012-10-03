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

# Shared code to be extended by component-specific APIs
module Shared
  
  # @abstract A dynamic collection of items
  class Collection < Shared::Resource

    include Enumerable

    private

    attr_reader :entry_class

    public

    # @private
    def initialize(location, client, type, entry_class)
      @type = type
      @entry_class = entry_class
      super(location, client)
    end

    def reload
      super
      @items = nil
    end

    # Calls the block once for each item in the collection.
    #
    # @yieldparam item an item in the collection
    #
    # @return [void]
    def each
      @items ||= create_collection_entries
      @items.each { |item| yield item }
    end

    private

    def create_collection_entries
      entries_json = details[@type]
      if entries_json
        entries_json.collect { |json| @entry_class.new(Util::LinkUtils.get_self_link_href(json), client) }
      else
        []
      end
    end

  end

end