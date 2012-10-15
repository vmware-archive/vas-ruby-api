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
  
  # @abstract A collection that allows items to be created
  class MutableCollection < Collection

    # @private
    def create(payload, rel=nil)
      created = create_entry(client.post(location, payload, rel))
      reload
      created
    end

    # @private
    def create_image(path, payload=nil)
      created = create_entry(client.post_image(location, path, payload))
      reload
      created
    end

  end
end
