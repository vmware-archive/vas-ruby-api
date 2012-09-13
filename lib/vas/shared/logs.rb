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


module Shared

  # @abstract A node instance's logs
  class Logs < Shared::MutableCollection

    # @private
    def initialize(location, client, log_class)
      super(location, client, 'logs', log_class)
    end

  end

  # abstract A log file in a node instance
  class Log < Shared::Resource

    # @return [String] the name of the log
    attr_reader :name

    # @return [NodeInstance] the node instance that the log belongs to
    attr_reader :instance
    
    # @private
    def initialize(location, client, instance_type, instance_class)
      super(location, client)

      @name = details['name']
      @content_location = Util::LinkUtils.get_link_href(details, 'content')
      @instance = instance_class.new(Util::LinkUtils.get_link_href(details, instance_type), client)
    end

    # Retrieve the content of the log
    #
    # @param [Hash] options the options that control the content that is returned
    #
    # @option options [Integer] :start_line the start point, in lines, of the content to pass to
    #   the block. Omitting the parameter will result in content from the start of the file being
    #   passed. If the provided value is greater than the number of lines in the file, no content
    #   will be passed.
    #
    # @option options [Integer] :end_line the end point, in lines, of the content to pass to the
    #   block. Omitting the parameter will result in content up to the end of the file being
    #   passed. If the provided value is greater than the number of lines in the file, content up
    #   to and including the last line in the file will be passed.
    #
    # @yield [chunk] a chunk of the log's content
    #
    # @return [void]
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

    # @return [Integer] the size of the log
    def size
      client.get(location)['size']
    end

    # @return [Integer] the last modified stamp of the log
    def last_modified
      client.get(location)['last-modified']
    end

    # @return [String] a string representation of the log
    def to_s
      "#<#{self.class} name='#@name'>"
    end
  end
end