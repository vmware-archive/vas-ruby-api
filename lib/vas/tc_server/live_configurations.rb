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

  # Used to enumerate an Instance's live configuration
  class LiveConfigurations < Shared::Collection

    def initialize(location, client) #:nodoc:
      super(location, client, "live-configurations")
    end

    private
    def create_entry(json)
      Configuration.new(Util::LinkUtils.get_self_link_href(json), client)
    end

  end

end