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
    
    include Deletable

    # @return [String] the name of the log
    attr_reader :name

    # @return [Integer] the size of the log
    attr_reader :size

    # @return [Integer] the last modified stamp of the log
    attr_reader :last_modified
    
    # @private
    def initialize(location, client, instance_type, instance_class)
      super(location, client)

      @content_location = Util::LinkUtils.get_link_href(details, 'content')
      @instance_location = Util::LinkUtils.get_link_href(details, instance_type)

      @instance_class = instance_class
    end

    # Reloads the log's details from the server
    #
    # @return [void]
    def reload
      super
      @name = details['name']
      @size = details['size']
      @last_modified = details['last-modified']
      @instance = nil
    end


    # Retrieves the content of the log from the server
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

    # @return [NodeInstance] the node instance that the log belongs to
    def instance
      @instance ||= @instance_class.new(@instance_location, client)
    end

    # @return [String] a string representation of the log
    def to_s
      "#<#{self.class} name='#@name' size='#@size' last_modified='#@last_modified'>"
    end
  end
end