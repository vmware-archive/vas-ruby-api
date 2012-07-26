module Shared

  # A configuration file that is pending and will be made live the next time its instance is started
  class PendingConfiguration < Configuration

    # Updates the configuration to contain +new_content+
    def content=(new_content)
      client.post(content_location, new_content)
      @size = client.get(location)['size']
    end

  end

end