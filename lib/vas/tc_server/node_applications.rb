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

  # Used to enumerate a node instance's applications
  class NodeApplications < Shared::Collection

    # @private
    def initialize(location, client)
      super(location, client, 'applications', NodeApplication)
    end

  end

  # An application on a node instance
  class NodeApplication < Shared::Resource

    # @return [String] the application's context path
    attr_reader :context_path

    # @return [String] the application's name
    attr_reader :name

    # @return [String] the service the application will deploy its revisions to
    attr_reader :service

    # @return [String] the host the application will deploy its revisions to
    attr_reader :host

    # @private
    def initialize(location, client)
      super(location, client)

      @group_application_location = Util::LinkUtils.get_link_href(details, 'group-application')
      @instance_location = Util::LinkUtils.get_link_href(details, 'node-instance')
      @revisions_location = Util::LinkUtils.get_link_href(details, 'node-revisions')

      @context_path = details['context-path']
      @name = details['name']
      @service = details['service']
      @host = details['host']
    end

    # @return [NodeInstance] the node instance that contains the application
    def instance
      @instance ||= NodeInstance.new(@instance_location, client)
    end

    # @return [Application] the application that this node application is a member of
    def group_application
      @group_application ||= Application.new(@group_application_location, client)
    end

    # @return [NodeRevisions] the application's revisions
    def revisions
      @revisions ||= NodeRevisions.new(@revisions_location, client)
    end

    # @return [String] a string representation of the node application
    def to_s
      "#<#{self.class} name='#@name' context_path='#@context_path' service='#@service' host='#@host'>"
    end

  end

end