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
  
  # The security configuration for a resource
  class Security

    # @return [Hash] The permissions of the resource
    attr_reader :permissions

    # @return [String] the owner of the resource
    attr_reader :owner

    # @return [String] the group of the resource
    attr_reader :group
    
    # @private
    attr_reader :location
    
    private
    attr_reader :client
  
    # @private
    def initialize(location, client)
      @location = location
      @client = client

      reload
    end
    
    public

    # Reloads the security configuration from server
    def reload
      json = @client.get(location)
      @owner = json["owner"]
      @group = json["group"]
      @permissions = json["permissions"]
    end

    # @return [String] a string representation of this security object
    def to_s
      "#<#{self.class} owner='#@owner' group='#@group' permissions='#@permissions'>"
    end
    
  end
  
end