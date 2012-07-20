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

    # The permissions of the resource
    attr_reader :permissions

    # The owner of the resource
    attr_reader :owner

    # The group of the resource
    attr_reader :group

    attr_reader :location #:nodoc:

    private
    attr_reader :client
  
    def initialize(location, client) #:nodoc:
      json = client.get(location)
  
      @owner = json["owner"]
      @group = json["group"]
      @permissions = json["permissions"]
    end
  
    def to_s #:nodoc:
      "#<#{self.class} owner='#@owner' group='#@group' permissions='#@permissions'>"
    end
    
  end
  
end