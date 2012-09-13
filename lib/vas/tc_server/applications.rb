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

  # Used to enumerate, create, and delete applications
  class Applications < Shared::MutableCollection

    def initialize(location, client) #:nodoc:
      super(location, client, "applications", Application)
    end

    # Creates an new application 
    # 
    # @param name [String] the name of the application
    # @param context_path [String] the context path of the application
    # @param service [String] the service that the application will deploy its revisions to
    # @param host [String] the host that the application will deploy its revisions to
    #
    # @return [Application] the new application
    def create(name, context_path, service, host)
      Application.new(client.post(location, {"context-path" => context_path, :name => name, :host => host, :service => service}, "group-application"), client)
    end

    private
    def create_entry(json)
      Application.new(Util::LinkUtils.get_self_link_href(json), client)
    end
  end

  # An application
  class Application < Shared::Resource

    # @return [String] the application's context path
    attr_reader :context_path

    # @return [String] the application's name
    attr_reader :name

    # @return [String] the service the application will deploy its revisions to
    attr_reader :service

    # @return [String] the host the application will deploy its revisions to
    attr_reader :host

    # @return [Revisions] the application's revisions
    attr_reader :revisions
    
    # @return [Instance] the instance that contains the application
    attr_reader :instance

    # @private
    def initialize(location, client)
      super(location, client)

      @revisions = Revisions.new(Util::LinkUtils.get_link_href(details, "group-revisions"), client)
      @context_path = details["context-path"]
      @name = details["name"]
      @service = details["service"]
      @host = details["host"]
      @instance = Instance.new(Util::LinkUtils.get_link_href(details, "group-instance"), client)
    end

    # @return [NodeApplication[]] the application's individual node applications
    def node_applications
      node_applications = []
      Util::LinkUtils.get_link_hrefs(client.get(location), 'node-application').each {
          |node_application_location| node_applications << NodeApplication.new(node_application_location, client)}
      node_applications
    end

    # @return [String] a string representation of the application
    def to_s
      "#<#{self.class} name='#@name' context_path='#@context_path' service='#@service' host='#@host'>"
    end

  end

end