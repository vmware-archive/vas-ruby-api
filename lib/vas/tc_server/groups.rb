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

  # Used to enumerate, create, and delete tc Server groups.
  class Groups < Shared::MutableCollection

    def initialize(location, client) #:nodoc:#
      super(location, client, "groups")
    end

    # Creates a Group named +name+ from the given +nodes+.
    def create(name, nodes)
      node_locations = []
      nodes.each { |node| node_locations << node.location }
      Group.new(client.post(location, {:name => name, :nodes => node_locations}, "group"), client)
    end

    private
    def create_entry(json)
      Group.new(Util::LinkUtils.get_self_link_href(json), client)
    end

  end

  # A tc Server group
  class Group < Shared::Resource

    # The group's Installations
    attr_reader :installations

    # The group's Instances
    attr_reader :instances

    # The name of the group
    attr_reader :name

    # An array of the group's Node s
    attr_reader :nodes

    def initialize(location, client) #:nodoc:#
      super(location, client)

      @name = details["name"]
      @installations = Installations.new(Util::LinkUtils.get_link_href(details, "installations"), client)
      @instances = Instances.new(Util::LinkUtils.get_link_href(details, "group-instances"), client)
    end

    # An array of every Node in the group
    def nodes
      nodes = []
      Util::LinkUtils.get_link_hrefs(client.get(location), "node").each { |node_location| nodes << Node.new(node_location, client)}
      nodes
    end

    # Updates the group to contain the given +nodes+.
    def update(nodes)
      node_locations = []
      nodes.each { |node| node_locations << node.location }
      client.post(location, {:nodes => node_locations})
    end

    def to_s #:nodoc:
      "#<#{self.class} name='#@name'>"
    end

  end

end