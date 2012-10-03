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

  # Used to enumerate tc Server instances on an individual node
  class NodeInstances < Shared::NodeInstances

    # @private
    def initialize(location, client)
      super(location, client, 'node-instances', NodeInstance)
    end

  end

  # A tc Server node instance
  class NodeInstance < Shared::NodeInstance
    
    # @return [String] the instance's layout
    attr_reader :layout
    
    # @return [String] the version of runtime used by the instance
    attr_reader :runtime_version
    
    # @return [Hash] the instance's services
    attr_reader :services

    # @private
    def initialize(location, client)
      super(location, client, Node, Logs, Instance, 'group-instance', NodeLiveConfigurations)

      @layout = details['layout']

      @applications_location = Util::LinkUtils.get_link_href(details, 'node-applications')
    end

    # Reloads the instance's details from the server
    # @return [void]
    def reload
      super
      @runtime_version = details['runtime-version']
      @services = details['services']
    end

    # @return [NodeApplications] the instance's applications
    def applications
      @applications ||= NodeApplications.new(@applications_location, client)
    end

    # @return [String] a string representation of the instance
    def to_s
      "#<#{self.class} name='#{name}' layout='#@layout' runtime_version='#@runtime_version' services='#@services'>"
    end

  end

end