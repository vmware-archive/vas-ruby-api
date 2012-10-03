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


module WebServer

  # Used to enumerate, create, and delete Web Server groups
  class Groups < Shared::Groups

    # @private
    def initialize(location, client)
      super(location, client, Group)
    end

  end

  # A Web Server group
  class Group < Shared::MutableGroup

    # @private
    def initialize(location, client)
      super(location, client, Node, Installations)
      @instances_location = Util::LinkUtils.get_link_href(details, 'group-instances')
    end

    # @return [Instances] the group's instances
    def instances
      @instances ||= Instances.new(@instances_location, client)
    end
  end

end