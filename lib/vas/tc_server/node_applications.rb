#--
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
#++

module TcServer

  # Used to enumerate a NodeInstance's NodeApplication s
  class NodeApplications < Shared::Collection

    def initialize(location, client) #:nodoc:
      super(location, client, "applications", NodeApplication)
    end

  end

  # A node application
  class NodeApplication < Shared::Resource

    # The application's context path
    attr_reader :context_path

    # The application's name
    attr_reader :name

    # The service the application will deploy its revisions to
    attr_reader :service

    # The host the application will deploy its revisions to
    attr_reader :host

    # The application's NodeRevisions
    attr_reader :revisions

    # The Application that this node application is a member of
    attr_reader :group_application

    def initialize(location, client) #:nodoc:
      super(location, client)

      @revisions = NodeRevisions.new(Util::LinkUtils.get_link_href(details, "node-revisions"), client)

      @context_path = details["context-path"]
      @name = details["name"]
      @service = details["service"]
      @host = details["host"]

      @instance_location = Util::LinkUtils.get_link_href(details, "node-instance")

      @group_application = Application.new(Util::LinkUtils.get_link_href(details, "group-application"), client)
    end

    # The node instance that contains the application
    def instance
      NodeInstance.new(@instance_location, client)
    end

    def to_s #:nodoc:
      "#<#{self.class} name='#@name' context_path='#@context_path' service='#@service' host='#@host'>"
    end

  end

end