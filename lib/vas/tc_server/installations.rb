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

module TcServer

  # Used to enumerate, create, and delete tc Server installations.
  class Installations < Shared::Installations
    
    def initialize(location, client) #:nodoc:
      super(location, client, Installation)
    end
    
  end
  
  # A tc Server installation
  class Installation < Shared::Installation

    # The versions of the tc Server runtime that are supported by the installation
    attr_reader :runtime_versions

    def initialize(location, client) #:nodoc:
      super(location, client, InstallationImage, Group)

      @runtime_versions = details["runtime-versions"]
      @templates_location = Util::LinkUtils.get_link_href(details, "templates")
    end
    
    # The installation's templates
    def templates
      Templates.new(@templates_location, client)
    end

    # An array of the instances that are using the installation
    def instances
      retrieve_instances("group-instance", Instance);
    end
    
  end
  
end