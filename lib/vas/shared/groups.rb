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

  # @abstract A collection of groups
  class Groups < MutableCollection

    # @private
    def initialize(location, client, group_class)
      super(location, client, 'groups', group_class)
    end

    # Creates a new group 
    #
    # @param name [String] the group's name
    # @param nodes [GroupableNode[]] the group's nodes
    #
    # @return [Group] the new group
    def create(name, nodes)
      payload = {:name => name,
                 :nodes => nodes.collect { |node| node.location }}
      super(payload, 'group')
    end

  end

  # @abstract A collection of one or more nodes
  class Group < Shared::Resource

    # @return [String] the group's name
    attr_reader :name

    # @private
    def initialize(location, client, nodes_class, installations_class)
      super(location, client)

      @installations_class = installations_class
      @nodes_class = nodes_class

      @installations_location = Util::LinkUtils.get_link_href(details, 'installations')

      @name = details['name']
    end

    # Reloads the group's details from the server
    def reload
      super
      @nodes = nil
    end

    # @return [Installations] the group's installations
    def installations
      @installations ||= @installations_class.new(@installations_location, client)
    end

    public

    # @return [GroupableNode[]] the group's nodes
    def nodes
      @nodes ||= create_resources_from_links('node', @nodes_class)
    end

    # @return [String] a string representation of the group
    def to_s
      "#<#{self.class} name='#@name'>"
    end

  end

  # @abstract A group that supports changes to it membership
  class MutableGroup < Group

    # Updates the group to contain the given nodes
    #
    # @param nodes [GroupableNode[]] the group's nodes
    #
    # @return [void]
    def update(nodes)
      node_locations = []
      nodes.each { |node| node_locations << node.location }
      client.post(location, {:nodes => node_locations})
      reload
    end

  end

end