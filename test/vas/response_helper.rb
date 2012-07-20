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

class ResponseHelper

  def ResponseHelper.get_response(component = nil, response)
    if component.nil?
      JSON.parse(IO.read(File.dirname(__FILE__) + "/responses/#{response}.json"))
    else
      JSON.parse(IO.read(File.dirname(__FILE__) + "/#{component}/responses/#{response}.json"))
    end
  end

end