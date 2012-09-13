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


# The main entry point to the vFabric Administration Server API.
class VFabricAdministrationServer

  # @return [Gemfire::Gemfire] the GemFire API
  attr_reader :gemfire

  # @return [RabbitMq::RabbitMq] the RabbitMQ API
  attr_reader :rabbitmq

  # @return [TcServer::TcServer] the tc Server API
  attr_reader :tc_server

  # @return [VFabric::VFabric] the vFabric API
  attr_reader :vfabric

  # Creates an entry point that will connect to a vFabric Administration Server. 
  # @param [Hash] configuration the connection configuration
  # @option configuration [String] :username ('admin') The username to use to authenticate with the server
  # @option configuration [String] :password ('vmware') The password to use to authenticate with the server
  # @option configuration [String] :host ('localhost') The host of the server
  # @option configuration [Integer] :port (8443) The HTTPS port of the server
  def initialize(configuration = {})
    @client = Util::Client.new(configuration[:username] || "admin", configuration[:password] || "vmware")

    host = configuration[:host] || "localhost"
    port = configuration[:port] || 8443

    @tc_server = TcServer::TcServer.new("https://#{host}:#{port}/tc-server/v1", @client)
    @vfabric = VFabric::VFabric.new("https://#{host}:#{port}/vfabric/v1", @client)
    @rabbitmq = RabbitMq::RabbitMq.new("https://#{host}:#{port}/rabbitmq/v1", @client)
    @gemfire = Gemfire::Gemfire.new("https://#{host}:#{port}/gemfire/v1", @client)
  end
  
end