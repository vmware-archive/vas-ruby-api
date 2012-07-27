module Shared

  class PendingConfigurations < MutableCollection

    # Creates a configuration with the given +path+ in the instance and the given +content+
    def create(path, content)
      entry_class.new(client.post_image(location, content, { :path => path }), client)
    end

  end

  # A configuration file that is pending and will be made live the next time its instance is started
  class PendingConfiguration < Configuration

    # Updates the configuration to contain +new_content+
    def content=(new_content)
      client.post(content_location, new_content)
      @size = client.get(location)['size']
    end

  end

end