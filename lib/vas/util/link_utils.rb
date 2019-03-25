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


# @private
module Util

  # @private
  class LinkUtils

    def LinkUtils.get_link_hrefs(json, rel)
      hrefs = []
      json["links"].select { |link| link["rel"] == rel }.each { |item| hrefs << item["href"] }
      hrefs
    end

    def LinkUtils.get_self_link_href(json)
      LinkUtils.get_link_hrefs(json, "self")[0]
    end

    def LinkUtils.get_link_href(json, rel)
      hrefs = get_link_hrefs(json, rel)
      if (hrefs.length > 0)
        hrefs[0]
      else
        nil
      end
    end

  end

end