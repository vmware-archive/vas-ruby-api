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


module TcServer

  # Used to enumerate, create, and delete tc Server instances.
  class Instances < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, "group-instances", Instance)
    end

    # Creates a new instance
    #
    # @param installation [Installation] the installation to be used by the instance
    # @param name [String] the name of the instance
    # @param options [Hash] optional configuration
    #
    # @option options :properties [Hash] configuration properties that customise the instance
    # @option options :runtime_version [String] the version of the runtime to be used by the 
    #   instance. Must be one of the +runtime_versions+ available in the +installation+.
    #   Defaults to the latest version that is available in the installation
    # @option options :templates [Template[]] the templates to use when creating the instance
    # @option options :layout [String] the layout to use when creating the instance. Valid
    #   values are +COMBINED+ and +SEPARATE+. Defaults to +SEPARATE+
    #
    # @return [Instance] the new instance
    def create(installation, name, options = {})
      payload = { :installation => installation.location, :name => name }
      
      if options.has_key?(:properties)
        payload[:properties] = options[:properties]
      end
      
      if options.has_key?(:runtime_version)
        payload['runtime-version'] = options[:runtime_version]
      end
      
      if options.has_key?(:templates)
        template_locations = []
        options[:templates].each { |template| template_locations << template.location }
        payload[:templates] = template_locations
      end
      
      if options.has_key?(:layout)
        payload[:layout] = options[:layout]
      end

      super(payload, 'group-instance')
    end

  end

  # A tc Server instance
  class Instance < Shared::Instance
    
    # @return [String] the instance's layout
    attr_reader :layout
    
    # @return [String] the version of runtime used by the instance
    attr_reader :runtime_version
    
    # @return [Hash] the instance's services
    attr_reader :services

    # @private
    def initialize(location, client)
      super(location, client, Group, Installation, LiveConfigurations, PendingConfigurations, NodeInstance, 'node-instance')

      @layout = details['layout']
    end

    # Reloads the instance's details from the server
    # @return [void]
    def reload
      super
      @runtime_version = details['runtime-version']
      @services = details['services']
    end

    # @return [Applications] the instance's applications
    def applications
      @applications ||= Applications.new(Util::LinkUtils.get_link_href(details, 'group-applications'), client)
    end

    # Updates the installation and, optionally, the +runtime_version+ used by the instance
    #
    # @param installation [Installation] the installation to be used by the instance
    # @param runtime_version [String] the version of the runtime to be used by the instance
    #
    # @return [void]
    def update(installation, runtime_version = nil)
      payload = { :installation => installation.location }
      if runtime_version
        payload['runtime-version'] = runtime_version
      end
      client.post(location, payload)
      reload
    end

    # @return [String] a string representation of the instance
    def to_s
      "#<#{self.class} name='#{name}' layout='#@layout' runtime_version='#@runtime_version' services='#@services'>"
    end

  end

end