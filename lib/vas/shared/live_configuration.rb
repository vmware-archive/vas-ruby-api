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

  # @abstract A live configuration file in an instance
  class LiveConfiguration < Shared::Configuration

    # @private
    def initialize(location, client, instance_type, instance_class, node_live_configuration_class)
      super(location, client, instance_type, instance_class)
      @node_live_configuration_class = node_live_configuration_class
    end

    # @return [NodeLiveConfiguration[]] the configuration's node configurations
    def node_configurations
      node_live_configurations = []
      Util::LinkUtils.get_link_hrefs(client.get(location), 'node-live-configuration').each {
          |configuration_location| node_live_configurations <<
            @node_live_configuration_class.new(configuration_location, client)}
      node_live_configurations
    end

  end

end