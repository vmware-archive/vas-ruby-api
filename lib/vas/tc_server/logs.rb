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

module TcServer

  # Used to enumerate a NodeInstance's Log s.
  class Logs < Shared::MutableCollection

    def initialize(location, client) #:nodoc:
      super(location, client, 'logs')
    end

    private
    def create_entry(json)
      Log.new(Util::LinkUtils.get_self_link_href(json), client)
    end
  end

  # A Log file in a NodeInstance
  class Log < Shared::Resource

    # The name of the log
    attr_reader :name

    # The size of the log
    attr_reader :size

    # The last modified stamp of the log
    attr_reader :last_modified

    # The NodeInstance that the log belongs to
    attr_reader :instance

    def initialize(location, client) #:nodoc:
      super(location, client)

      @name = details['name']
      @size = details['size']
      @last_modified = details['last-modified']
      @content_location = Util::LinkUtils.get_link_href(details, 'content')
      @instance = NodeInstance.new(Util::LinkUtils.get_link_href(details, 'node-instance'), client)
    end

    # The Log's content. The content that is passed to the block can be controlled using +options+.
    #
    # Recognized options are:
    #
    # start_line::  The start point, in lines, of the content to pass to the block. Omitting the parameter will result
    #               in content from the start of the file being passed. If the provided value is greater than the
    #               number of lines in the file, no content will be passed.
    # end_line::    The end point, in lines, of the content to pass to the block. Omitting the parameter will result in
    #               content up to the end of the file being passed. If the provided value is greater than the number of
    #               lines in the file, content up to and including the last line in the file will be passed.
    def content(options = {}, &block)
      query=""
      if (!options[:start_line].nil?)
        query << "start-line=#{options[:start_line]}"
      end
      if (!options[:end_line].nil?)
        if (query.length > 0)
          query << '&'
        end
        query << "end-line=#{options[:end_line]}"
      end

      if (query.length > 0)
        client.get_stream("#{@content_location}?#{query}", &block)
      else
        client.get_stream(@content_location, &block)
      end
    end

    def to_s #:nodoc:
      "#<#{self.class} name='#@name' size'#@size' services='#@last_modified'>"
    end
  end
end