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

module Rabbit

  # Used to enumerate Rabbit instances on an individual node
  class NodeInstances < Shared::NodeInstances

    def initialize(location, client) #:nodoc:
      super(location, client, "node-instances", NodeInstance)
    end

  end

  # A Rabbit node instance
  class NodeInstance < Shared::NodeInstance

    def initialize(location, client) #:nodoc:
      super(location, client, Node, Logs, Instance, 'group-instance')
    end

  end

end