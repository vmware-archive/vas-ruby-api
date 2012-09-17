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


class StubClient

  def initialize
    @location_regex = /https:\/\/localhost:8443\/(.*)\/v1\/(?:([^\/]*)\/(?:([^\/]*)\/(?:([^\/]*)\/(?:([^\/]*)\/(?:([^\/]*)\/(?:([^\/]*)\/(?:([^\/]*)\/(?:([^\/]*)\/(?:([^\/]*)\/(?:([^\/]*)\/)?)?)?)?)?)?)?)?)?)?/
    @delegate = MiniTest::Mock.new
  end

  def get(location)
    @location_regex.match location

    response_path = "#{File.dirname(__FILE__)}/responses/#{$~.captures[0]}/"
    
    captures = $~.captures.find_all{|capture| !capture.nil?}
    
    if (captures.size == 1)
      response_path << "root.json"
    else
      joined_captures = captures[1..-1].find_all{|capture| !integer?(capture) && capture != 'state'}.join("-")

      if (joined_captures.length > 0)
        response_path << "#{joined_captures}-"
      end

      final_capture = captures[-1]

      if (integer?(final_capture))
        response_path << "detail.json"
      elsif (final_capture == "state")
        response_path << "state.json"
      else
        response_path << "list.json"
      end
      
    end

    return JSON.parse(IO.read(response_path))

    raise RuntimeError.new("No match found for '#{location}'")

  end

  def post (location, payload, rel = nil)
    if rel.nil?
      @delegate.post(location, payload)
    else
      @delegate.post(location, payload, rel)
    end

  end

  def post_image(location, path, metadata = nil)
    if (metadata.nil?)
      @delegate.post_image(location, path)
    else
      @delegate.post_image(location, path, metadata)
    end
  end

  def delete(location)
    @delegate.delete(location)
  end

  def expect(name, return_value, arguments)
    @delegate.expect(name, return_value, arguments)
  end

  def verify
    @delegate.verify
  end

  def get_stream(location, &block)
    query = URI(location).query

    start_line = 0;
    end_line = 2;

    if (!query.nil?)
      parameters = CGI.parse(query)
      if !parameters['start-line'][0].nil?
        start_line = Integer(parameters['start-line'][0])
      end
      if !parameters['end-line'][0].nil?
        end_line = Integer(parameters['end-line'][0])
      end
    end

    ["some", "streamed", "content"][start_line..end_line].each { |content| block.call content }
  end
  
  @private
  def integer?(string)
    true if Integer(string) rescue false
  end

end