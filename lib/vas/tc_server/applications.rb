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
      payload = {'context-path' => context_path,
                 :name => name,
                 :host => host,
                 :service => service}
      super(payload, 'group-application')
    end

  end

  # An application
  class Application < Shared::Resource

    include Shared::Deletable

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

      @revisions_location = Util::LinkUtils.get_link_href(details, 'group-revisions')
      @instance_location = Util::LinkUtils.get_link_href(details, 'group-instance')

      @context_path = details['context-path']
      @name = details['name']
      @service = details['service']
      @host = details['host']
    end

    # Reloads the application's details from the server
    # @return [void]
    def reload
      super
      @node_applications = nil
    end

    # @return [NodeApplication[]] the application's individual node applications
    def node_applications
      @node_applications ||= create_resources_from_links('node-application', NodeApplication)
    end

    # @return [Instance] the instance that contains the application
    def instance
      @instance ||= Instance.new(@instance_location, client)
    end

    # @return [Revisions] the application's revisions
    def revisions
      @revisions ||= Revisions.new(@revisions_location, client)
    end

    # @return [String] a string representation of the application
    def to_s
      "#<#{self.class} name='#@name' context_path='#@context_path' service='#@service' host='#@host'>"
    end

  end

end