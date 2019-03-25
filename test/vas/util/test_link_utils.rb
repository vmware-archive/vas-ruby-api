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


module Util
  class TestLinkUtils < MiniTest::Unit::TestCase
  
    def test_get_link_hrefs_with_no_links
      json = {"links" => []}
      hrefs = LinkUtils.get_link_hrefs json, "test"
      assert_equal 0, hrefs.size
    end
  
    def test_get_link_hrefs_with_no_links_with_matching_rel
      json = {"links" => [ {"href" => "href_one", "rel" => "foo"}]}
      hrefs = LinkUtils.get_link_hrefs json, "test"
      assert_equal 0, hrefs.size
    end
  
    def test_get_link_hrefs
      json = {"links" => [ {"href" => "href_one", "rel" => "test"}]}
      hrefs = LinkUtils.get_link_hrefs json, "test"
      assert_equal 1, hrefs.size
      assert_equal "href_one", hrefs[0]
    end

    def test_get_link_href_with_no_links
      json = {"links" => []}
      href = LinkUtils.get_link_href json, "test"
      assert_nil href
    end

    def test_get_link_href_with_no_links_with_matching_rel
      json = {"links" => [ {"href" => "href_one", "rel" => "foo"}]}
      href = LinkUtils.get_link_href json, "test"
      assert_nil href
    end

    def test_get_link_href
      json = {"links" => [ {"href" => "href_one", "rel" => "test"}]}
      href = LinkUtils.get_link_href json, "test"
      assert_equal "href_one", href
    end
  
    def test_get_self_link_href_with_no_links
      json = {"links" => []}
      href = LinkUtils.get_self_link_href json
      assert_nil href
    end
  
    def test_get_self_link_href
      json = {"links" => [ {"href" => "href_one", "rel" => "self"}]}
      href = LinkUtils.get_self_link_href json
      assert_equal "href_one", href
    end
  
  end
end