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

module Util #:nodoc: all

  class Client
  
    TASK_POLLING_INTERVAL = 1
  
    def initialize(username, password)
      @username = username
      @password = password
    end
  
    def get(location)
  
      req = Net::HTTP::Get.new(location)
  
      do_request(req) { |res|
        case res.code
          when "200"
            return JSON.parse(res.body)
          else
            raise_vas_exception(res)
        end
      }
  
    end
  
    def get_stream(location, &block)
  
      req = Net::HTTP::Get.new(location)
  
      do_request(req) { |res|
        case res.code
          when "200"
            return res.read_body(&block)
          else
            raise_vas_exception(res)
        end
      }
  
    end
  
    def delete(location)
      req = Net::HTTP::Delete.new(location)
  
      do_request(req) { |res|
        case res.code
          when "200"
            return
          when "202"
            await_task(res["Location"])
          else
            raise_vas_exception(res)
        end
      }
    end
  
    def post(location, payload, rel = nil)
  
      req = Net::HTTP::Post.new(location)
  
      req['Content-Type'] = "application/json"
      req.body = payload.to_json
  
      do_request(req) { |res|
        case res.code
          when "202"
            return await_task(res["Location"], rel)
          else
            raise_vas_exception(res)
        end
      }
    end
  
    def post_image(location, path, metadata)
      File.open(path) { |image|
        req = Net::HTTP::Post::Multipart.new(location, :data => UploadIO.new(image, "application/octet-stream"), :metadata => UploadIO.new(StringIO.new(metadata.to_json), "application/json"))
  
        do_request(req) { |res|
          case res.code
            when "201"
              return res["Location"]
            else
              raise_vas_exception(res)
          end
        }
      }
    end
  
    private
    def do_request(req)
      req.basic_auth(@username, @password)
      uri = URI(req.path)
  
      result = nil
  
      Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) { |http|
        http.request(req) { |res|
          yield res
        }
      }
  
    end
  
    def await_task(task_location, rel = nil)
      while true
        task = get(task_location)
        case task["status"]
          when "PENDING"
          when "IN_PROGRESS"
            sleep TASK_POLLING_INTERVAL
          when "SUCCESS"
            if rel
              return LinkUtils.get_link_hrefs(task, rel)[0]
            else
              return
            end
          else
            raise VasException.new([task["message"], task["detail"]])
        end
      end
    end
  
    def raise_vas_exception(res)
      messages = []
      begin
        json = JSON.parse(res.body)
        json["reasons"].each { |reason| messages << reason["message"]}
      ensure
        raise VasException.new(res.code, messages)
      end
    end
    
  end
  
end