# vFabric Administration Server Ruby API
# Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


module Shared

  # @abstract A collection of node instances
  class NodeInstances < Shared::Collection

    private 

    def initialize(location, client, type, entry_class)
      super(location, client, type, entry_class)
    end

  end

  # @abstract A node instance, i.e. an instance on an individual node
  class NodeInstance < Shared::StateResource

    # @return [String] the instance's name
    attr_reader :name

    # @private
    def initialize(location, client, node_class, logs_class, group_instance_class, group_instance_type,
        node_live_configurations_class)
      super(location, client)

      @name = details['name']

      @node_class = node_class
      @logs_class = logs_class
      @group_instance_class = group_instance_class
      @live_configurations_class = node_live_configurations_class

      @node_location = Util::LinkUtils.get_link_href(details, 'node')
      @logs_location = Util::LinkUtils.get_link_href(details, 'logs')
      @group_instance_location = Util::LinkUtils.get_link_href(details, group_instance_type)
      @live_configurations_location = Util::LinkUtils.get_link_href(details, 'node-live-configurations')
    end

    # @return [GroupableNode] the node that contains this instance
    def node
      @node ||= @node_class.new(@node_location, client)
    end

    # @return [Logs] the instance's logs
    def logs
      @logs ||= @logs_class.new(@logs_location, client)
    end

    # @return [Instance] the node instance's group instance
    def group_instance
      @group_instance ||= @group_instance_class.new(@group_instance_location, client)
    end

    # @return the node instance's live configuration
    def live_configurations
      @live_configurations ||= @live_configurations_class.new(@live_configurations_location, client)
    end

    # @return [String] a string representation of the node instance
    def to_s
      "#<#{self.class} name='#@name'>"
    end

  end

end