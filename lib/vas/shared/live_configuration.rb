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

  # @abstract A live configuration file in an instance
  class LiveConfiguration < Shared::Configuration

    # @private
    def initialize(location, client, instance_type, instance_class, node_live_configuration_class)
      super(location, client, instance_type, instance_class)
      @node_live_configuration_class = node_live_configuration_class
    end

    # Reloads the live configuration's details from the server
    def reload
      super
      @node_live_configurations = nil
    end

    # @return [NodeLiveConfiguration[]] the configuration's node configurations
    def node_configurations
      @node_live_configurations ||= create_resources_from_links('node-live-configuration',
                                                                @node_live_configuration_class)
    end

  end

end