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


module Gemfire

  # Used to enumerate, create, and delete a cache server's pending application code.
  class PendingApplicationCodes < Shared::MutableCollection

    # @private
    def initialize(location, client)
      super(location, client, 'pending-application-code', PendingApplicationCode)
    end

    # Creates a new pending application code
    #
    # @param image [ApplicationCodeImage] the image to create the application code from
    #
    # @return [ApplicationCode] the new application code
    def create(image)
      super({:image => image.location})
    end

  end
  
  # An application code that is pending
  class PendingApplicationCode < ApplicationCode
    include Shared::Deletable
  end

end
