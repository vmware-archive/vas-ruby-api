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

  # Used to enumerate tc Server NodeInstance s.
  class NodeInstances < Shared::Collection

    def initialize(location, client) #:nodoc:
      super(location, client, "node-instances")
    end

    private
    def create_entry(json)
      NodeInstance.new(Util::LinkUtils.get_self_link_href(json), client)
    end

  end

  # A tc Server node instance
  class NodeInstance < Shared::StateResource

    # The instance's name
    attr_reader :name
    
    # The instance's layout
    attr_reader :layout
    
    # The version of runtime used by the instance
    attr_reader :runtime_version
    
    # The instance's services
    attr_reader :services

    # The instance's NodeApplications
    attr_reader :applications

    # The node that contains this instance
    attr_reader :node

    # The instance's Logs
    attr_reader :logs

    def initialize(location, client) #:nodoc:
      super(location, client)

      @name = details["name"]
      @layout = details["layout"]
      @runtime_version = details["runtime-version"]
      @services = details["services"]

      @applications = NodeApplications.new(Util::LinkUtils.get_link_href(details, "node-applications"), client)

      @node = Node.new(Util::LinkUtils.get_link_href(details, "node"), client)
      @logs = Logs.new(Util::LinkUtils.get_link_href(details, "logs"), client)
    end

    def to_s #:nodoc:
      "#<#{self.class} name='#@name' runtime_version='#@runtime_version' services='#@services' layout='#@layout'>"
    end

  end

end