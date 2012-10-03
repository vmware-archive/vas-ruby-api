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

  # Used to enumerate, create, and delete Web Server installations
  class Installations < Shared::Installations
    
    # @private
    def initialize(location, client)
      super(location, client, Installation)
    end
    
  end
  
  # A Web Server installation
  class Installation < Shared::Installation

    # @private
    def initialize(location, client)
      super(location, client, InstallationImage, Group)
    end

    # Reloads the installation's details from the server
    #
    # @return [void]
    def reload
      super
      @instances = nil
    end

    # @return [Instance[]] the instances that are using the installation
    def instances
      @instances ||= create_resources_from_links('group-instance', Instance)
    end
    
  end
  
end