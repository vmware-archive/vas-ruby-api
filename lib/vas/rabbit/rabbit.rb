module Rabbit

  class Rabbit
    # The Rabbit groups
    attr_reader :groups

    # The Rabbit installation images
    attr_reader :installation_images

    # The Rabbit plugin images
    attr_reader :plugin_images

    # The Rabbit nodes
    attr_reader :nodes

    def initialize(location, client) #:nodoc:

      json = client.get(location)

      @groups = Groups.new(Util::LinkUtils.get_link_href(json, "groups"), client)
      @installation_images = InstallationImages.new(Util::LinkUtils.get_link_href(json, "installation-images"), client)
      @plugin_images = PluginImages.new(Util::LinkUtils.get_link_href(json, "plugin-images"), client)
      @nodes = Nodes.new(Util::LinkUtils.get_link_href(json, "nodes"), client)
    end

  end

end
