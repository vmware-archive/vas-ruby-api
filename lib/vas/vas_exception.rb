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


# Raised to indicate a failure has occurred when communicating with the vFabric Administration Server
class VasException < RuntimeError

  # @return [Integer] the HTTP error code returned by the server
  attr_reader :code

  # @return [String[]] the error messages, if any, returned by the server
  attr_reader :messages

  # @private
  def initialize(messages, code=nil)
    @code = code
    @messages = messages
  end
  
end