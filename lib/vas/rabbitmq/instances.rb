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

module RabbitMq

  # Used to enumerate, create, and delete Rabbit instances.
  class Instances < Shared::MutableCollection

    def initialize(location, client) #:nodoc:
      super(location, client, "group-instances", Instance)
    end

    # Creates a new instance named +name+, using the installation +installation+.
    def create(installation, name)
      payload = { :installation => installation.location, :name => name }
      Instance.new(client.post(location, payload, "group-instance"), client)
    end

  end

  # A Rabbit instance
  class Instance < Shared::Instance

    # The instance's plugins
    attr_reader :plugins

    def initialize(location, client) #:nodoc:
      super(location, client, Group, Installation, LiveConfigurations, PendingConfigurations, NodeInstance, 'node-instance')
      @plugins = Plugins.new(Util::LinkUtils.get_link_href(details, "plugins"), client)
    end

    # Updates the instance to use the given +installation+
    def update(installation, runtime_version = nil)
      client.post(location, { :installation => installation.location });
    end

  end

end