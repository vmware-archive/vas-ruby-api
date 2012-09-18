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

class TestVFabricAdministrationServer < VasTestCase

  def test_initialization_against_10x_server
    client = StubClient.new ['sqlfire', 'web-server']
    delegate = client.delegate

    def delegate.get(location)
      raise VasException.new [], 404
    end

    vfabric_administration_server = VFabricAdministrationServer.new({:client => client})
    assert_nil(vfabric_administration_server.sqlfire)
    assert_nil(vfabric_administration_server.web_server)
    assert_not_nil(vfabric_administration_server.gemfire)
    assert_not_nil(vfabric_administration_server.rabbitmq)
    assert_not_nil(vfabric_administration_server.tc_server)
  end

  def test_initialization_against_11x_server
    client = StubClient.new

    vfabric_administration_server = VFabricAdministrationServer.new({:client => client})
    assert_not_nil(vfabric_administration_server.gemfire)
    assert_not_nil(vfabric_administration_server.rabbitmq)
    assert_not_nil(vfabric_administration_server.sqlfire)
    assert_not_nil(vfabric_administration_server.tc_server)
    assert_not_nil(vfabric_administration_server.web_server)
  end

  def assert_not_nil (object)
    assert !object.nil?
  end

end