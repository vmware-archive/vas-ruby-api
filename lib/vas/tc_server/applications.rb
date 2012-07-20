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

  # Used to enumerate, create, and delete applications.
  class Applications < Shared::MutableCollection

    def initialize(location, client) #:nodoc:
      super(location, client, "applications")
    end

    # Creates an Application named +name+ with the given +context_path+. The application will deploy its revisions to the given
    # +service+ and +host+.
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

    # The application's context path
    attr_reader :context_path

    # The application's name
    attr_reader :name

    # The service the application will deploy its revisions to
    attr_reader :service

    # The host the application will deploy its revisions to
    attr_reader :host

    # The application's Revisions
    attr_reader :revisions

    def initialize(location, client) #:nodoc:
      super(location, client)

      @revisions = Revisions.new(Util::LinkUtils.get_link_href(details, "group-revisions"), client)

      @context_path = details["context-path"]
      @name = details["name"]
      @service = details["service"]
      @host = details["host"]

      @instance_location = Util::LinkUtils.get_link_href(details, "group-instance")
    end

    # The instance that contains the application
    def instance
      Instance.new(@instance_location, client)
    end

    def to_s #:nodoc:
      "#<#{self.class} name='#@name' context_path='#@context_path' service='#@service' host='#@host'>"
    end

  end

end