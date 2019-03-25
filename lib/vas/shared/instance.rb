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

  # @abstract A collection of instances
  class Instance < Shared::StateResource
    
    include Deletable

    # @return [String] the instance's name
    attr_reader :name

    # @private
    def initialize(location, client,
        group_class,
        installation_class,
        live_configurations_class,
        pending_configurations_class,
        node_instance_class,
        node_instance_type)

      super(location, client)

      @live_configurations_location = Util::LinkUtils.get_link_href(details, 'live-configurations')
      @pending_configurations_location = Util::LinkUtils.get_link_href(details, 'pending-configurations')
      @group_location = Util::LinkUtils.get_link_href(details, 'group')

      @group_class = group_class
      @installation_class = installation_class
      @node_instance_class = node_instance_class
      @live_configurations_class = live_configurations_class
      @pending_configurations_class = pending_configurations_class
      @node_instance_type = node_instance_type

      @name = details['name']
    end

    # Reloads the instance's details from the server
    #
    # @return [void]
    def reload
      super
      @installation_location = Util::LinkUtils.get_link_href(details, 'installation')
      @installation = nil
      @node_instances = nil
    end

    # @return [Installation] the installation that this instance is using
    def installation
      @installation ||= @installation_class.new(@installation_location, client)
    end

    # @return [NodeInstance[]] the instance's individual node instances
    def node_instances
      @node_instances ||= create_resources_from_links(@node_instance_type, @node_instance_class)
    end

    # @return [Group] the group that contains this instance
    def group
      @group ||= @group_class.new(@group_location, client)
    end

    # @return the instance's live configurations
    def live_configurations
      @live_configurations ||= @live_configurations_class.new(@live_configurations_location, client)
    end

    # @return the instance's pending configurations
    def pending_configurations
      @pending_configurations ||= @pending_configurations_class.new(@pending_configurations_location, client)
    end
    
    # Starts the instance
    #
    # @param serial [Boolean] +true+ if the starting of the individual instances represented by
    #   this group instance should happen serially, +false+ if they should happen in parallel
    def start(serial = false)
      client.post(@state_location, { :status => 'STARTED', :serial => serial })
    end
    
    # Stops the instance
    #
    # @param serial [Boolean] +true+ if the stoping of the individual instances represented by this
    #   group instance should happen serially, +false+ if they should happen in parallel
    def stop(serial = false)
      client.post(@state_location, { :status => 'STOPPED', :serial => serial })
    end

    # @return [String] a string representation of the instance
    def to_s
      "#<#{self.class} name='#@name'>"
    end

  end

end