# Management Plugin

This example illustrates the use of the vFabric Administration Server (VAS) Ruby API to provision a
RabbitMQ installation, create a Rabbit instance, and enable the management plugin on the instance.
The instance is then started and the example waits for `enter` to be pressed. At this point the
management plugin's web UI is available on port 55672. You can login with the default username
`guest` and the default password `guest`. Upon `enter` being pressed, the instance is stopped and
the provisioned environment is cleaned up.

The example creates a group from all of the nodes that are known to the server, i.e. thanks to
VAS's group-based administration, the provisioning of the Rabbit installation, creation of the
instance, and enabling of the management plugin will occur on every node that's known to the
server.

## Running the example

The example requires two arguments:

 * The path to the Rabbit installation image .zip file (Windows) or .tar.gz file (Unix)
 * The installation image's version

For example:

    ./management_plugin.rb rabbitmq-server-generic-unix-2.8.4.tar.gz 2.8.4

The example also supports a number of options, allowing you to customize the details used to connect
to the administration server. Use `--help` for more details:

    ./management_plugin.rb --help