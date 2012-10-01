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

  # @abstract A collection of instances
  class Instance < Shared::StateResource

    # @return [String] the instance's name
    attr_reader :name

    # @return the instance's live configurations
    attr_reader :live_configurations

    # @return the instance's pending configurations
    attr_reader :pending_configurations

    # @return [Group] the group that contains this instance
    attr_reader :group

    # @private
    def initialize(location, client,
        group_class,
        installation_class,
        live_configurations_class,
        pending_configurations_class,
        node_instance_class,
        node_instance_type)
      super(location, client)

      @name = details["name"]
      @live_configurations = live_configurations_class.new(Util::LinkUtils.get_link_href(details, "live-configurations"), client)
      @pending_configurations = pending_configurations_class.new(Util::LinkUtils.get_link_href(details, "pending-configurations"), client)
      @group = group_class.new(Util::LinkUtils.get_link_href(details, "group"), client)
      @installation_class = installation_class
      @node_instance_class = node_instance_class
      @node_instance_type = node_instance_type
    end

    # @return [Installation] the installation that this instance is using
    def installation
      @installation_class.new(Util::LinkUtils.get_link_href(client.get(location), 'installation'), client)
    end

    # @return [NodeInstance[]] the instance's individual node instances
    def node_instances
      node_instances = []
      Util::LinkUtils.get_link_hrefs(client.get(location), @node_instance_type).each {
          |node_instance_location| node_instances << @node_instance_class.new(node_instance_location, client)}
      node_instances
    end

    # @return [String] a string representation of the instance
    def to_s
      "#<#{self.class} name='#@name'>"
    end

  end

end