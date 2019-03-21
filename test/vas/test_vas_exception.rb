# vFabric Administration Server Ruby API
# Copyright (c) 2013 VMware, Inc. All Rights Reserved.
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

class TestVasException < VasTestCase

  def test_code_is_integer_when_initialized_with_integer
    exception = VasException.new [], 404
    assert(exception.code.is_a? Integer)
  end

  def test_code_is_integer_when_initialized_with_string
    exception = VasException.new [], '404'
    assert(exception.code.is_a? Integer)
  end

  def test_code_is_nil_when_initializaed_with_nil
    exception = VasException.new [], nil
    assert_nil(exception.code)
  end

end