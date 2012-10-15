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


module Util

  class TestClient < MiniTest::Unit::TestCase

    def teardown
      FakeWeb.clean_registry
    end

    def test_get_with_ok_response
      FakeWeb.register_uri(:get, "https://username:password@localhost:8443/test/location", :status =>["200", "OK"], :body => '{ "key" : "value" }')
      json = Client.new("username", "password").get("https://localhost:8443/test/location")
      assert_equal("value", json["key"])
    end

    def test_get_with_not_found_response
      FakeWeb.register_uri(:get, "https://username:password@localhost:8443/test/location", :status =>["404", "Not Found"])
      assert_raises(VasException) { Client.new("username", "password").get("https://localhost:8443/test/location") }
    end

    def test_get_stream_with_ok_response
      FakeWeb.register_uri(:get, "https://username:password@localhost:8443/test/location", :status =>["200", "OK"], :body => 'a stream of data')
      body = ""
      Client.new("username", "password").get_stream("https://localhost:8443/test/location") { |segment| body << segment}
      assert_equal("a stream of data", body)
    end

    def test_stream_with_not_found_response
      FakeWeb.register_uri(:get, "https://username:password@localhost:8443/test/location", :status =>["404", "Not Found"])
      assert_raises(VasException) { Client.new("username", "password").get_stream("https://localhost:8443/test/location") }
    end

    def test_delete_with_ok_response
      FakeWeb.register_uri(:delete, "https://username:password@localhost:8443/test/location", :status =>["200", "OK"])
      Client.new("username", "password").delete("https://localhost:8443/test/location")
      request = FakeWeb.last_request
      assert_instance_of(Net::HTTP::Delete, request)
      assert_equal("https://localhost:8443/test/location", request.path)
    end

    def test_delete_with_accepted_response
      FakeWeb.register_uri(:delete, "https://username:password@localhost:8443/test/location", :status =>["202", "Accepted"], :location => "https://localhost:8443/task/location")
      FakeWeb.register_uri(:get, "https://username:password@localhost:8443/task/location", :status =>["200", "OK"], :body => '{ "status" : "SUCCESS"}')
      FakeWeb.register_uri(:delete, "https://username:password@localhost:8443/task/location", :status =>["200", "OK"])
      Client.new("username", "password").delete("https://localhost:8443/test/location")

      request = FakeWeb.last_request
      assert_instance_of(Net::HTTP::Delete, request)
      assert_equal("https://localhost:8443/task/location", request.path)
    end

    def test_delete_with_error_response
      FakeWeb.register_uri(:delete, "https://username:password@localhost:8443/test/location", :status =>["403", "Forbidden"])
      assert_raises(VasException) { Client.new("username", "password").delete("https://localhost:8443/test/location") }
    end

    def test_post_with_accepted_response
      FakeWeb.register_uri(:post, "https://username:password@localhost:8443/test/location", :status =>["202", "Accepted"], :location => "https://localhost:8443/task/location")
      TasklessClient.new("username", "password").post("https://localhost:8443/test/location", { :foo => "bar"})

      request = FakeWeb.last_request
      assert_instance_of(Net::HTTP::Post, request)
      assert_equal("bar", JSON.parse(request.body)["foo"])
    end

    def test_post_with_error_response
      FakeWeb.register_uri(:post, "https://username:password@localhost:8443/test/location", :status =>["403", "Forbidden"])
      assert_raises(VasException) { Client.new("username", "password").post("https://localhost:8443/test/location", {}) }
    end

    def test_post_image_with_created_response
      FakeWeb.register_uri(:post, "https://username:password@localhost:8443/test/location", :status =>["201", "Created"], :location => "https://localhost:8443/image/location")
      assert_equal("https://localhost:8443/image/location", Client.new("username", "password").post_image("https://localhost:8443/test/location", "test/vas/image.txt", '{ "foo" : "bar"}'))
      request = FakeWeb.last_request
      assert_instance_of(Net::HTTP::Post::Multipart, request)
    end

    def test_post_image_with_error_response
      FakeWeb.register_uri(:post, "https://username:password@localhost:8443/test/location", :status =>["403", "Forbidden"], :location => "https://localhost:8443/image/location")
      assert_raises(VasException) { Client.new("username", "password").post_image("https://localhost:8443/test/location", "test/vas/image.txt", '{ "foo" : "bar"}') }
    end

    def test_await_task_with_no_rel_with_successful_outcome
      FakeWeb.register_uri(:get, "https://username:password@localhost:8443/task/location", [{ :status =>["200", "OK"], :body => '{ "status" : "PENDING"}' },
                                                                                            { :status =>["200", "OK"], :body => '{ "status" : "IN_PROGRESS"}' },
                                                                                            { :status =>["200", "OK"], :body => '{ "status" : "SUCCESS"}'} ])
      FakeWeb.register_uri(:delete, "https://username:password@localhost:8443/task/location", [{ :status =>["200", "OK"]}])
      Client.new("username", "password").send(:await_task, "https://localhost:8443/task/location")
      
      request = FakeWeb.last_request
      assert_instance_of(Net::HTTP::Delete, request)
      assert_equal("https://localhost:8443/task/location", request.path)
    end

    def test_await_task_with_rel_with_successful_outcome
      FakeWeb.register_uri(:get, "https://username:password@localhost:8443/task/location", [{ :status =>["200", "OK"], :body => '{ "status" : "PENDING"}' },
                                                                                            { :status =>["200", "OK"], :body => '{ "status" : "IN_PROGRESS"}' },
                                                                                            { :status =>["200", "OK"], :body => '{ "status" : "SUCCESS", "links" : [ { "rel" : "link-rel", "href" : "https://localhost:8443/link/location" } ] }'} ])
      FakeWeb.register_uri(:delete, "https://username:password@localhost:8443/task/location", [{ :status =>["200", "OK"]}])
      assert_equal("https://localhost:8443/link/location", Client.new("username", "password").send(:await_task, "https://localhost:8443/task/location", "link-rel"))
      
      request = FakeWeb.last_request
      assert_instance_of(Net::HTTP::Delete, request)
      assert_equal("https://localhost:8443/task/location", request.path)
    end

    def test_await_task_with_failure_outcome
      FakeWeb.register_uri(:get, "https://username:password@localhost:8443/task/location", [{ :status =>["200", "OK"], :body => '{ "status" : "PENDING"}' },
                                                                                            { :status =>["200", "OK"], :body => '{ "status" : "IN_PROGRESS"}' },
                                                                                            { :status =>["200", "OK"], :body => '{ "status" : "FAILURE"}'}])
      FakeWeb.register_uri(:delete, "https://username:password@localhost:8443/task/location", [{ :status =>["200", "OK"]}])
      assert_raises(VasException) { Client.new("username", "password").send(:await_task, "https://localhost:8443/task/location", "link-rel")}
      
      request = FakeWeb.last_request
      assert_instance_of(Net::HTTP::Delete, request)
      assert_equal("https://localhost:8443/task/location", request.path)
    end

    class TasklessClient < Client
      def await_task(task_location, rel)
        return "https://localhost:8443/task/result/location"
      end
    end

  end

end