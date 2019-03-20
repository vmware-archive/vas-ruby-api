# vFabric Administration Server Ruby API

The vFabric Administration Server (VAS) API is a Ruby library used for interacting with the
[vFabric Administration Server](https://www.vmware.com/support/pubs/vfabric-vas.html).

VAS's primary mode of interaction is via RESTful interface. This API enables the use of VAS using
rich Ruby types, eliminating the need for a detailed understanding of the REST API and its JSON
payloads.

## Requirements

The VAS Ruby API requires Ruby 1.8.7 or 1.9.x. It has been built and tested on 1.8.7 and 1.9.3.

## Installation

The VAS Ruby API is available on [RubyGems](https://rubygems.org/gems/vas). To install it run:

	gem install vas

## Getting started

### Examples

A number of [examples](https://github.com/vFabric/vas-ruby-api/tree/master/examples) are provided:

#### tc Server

* [Provision tc Server and deploy a web application](https://github.com/vFabric/vas-ruby-api/tree/master/examples/tc-server/web-application)

#### RabbitMQ

* [Provision Rabbit and enable the management plugin](https://github.com/vFabric/vas-ruby-api/tree/master/examples/rabbitmq/management-plugin)

#### VAS

* [Download, install, and start the VAS agent](https://github.com/vFabric/vas-ruby-api/tree/master/examples/rabbitmq/management-plugin)

### Documentation

You may also like to look at the [API documentation](https://www.rubydoc.info/gems/vas/frames).

##Licence

The VAS Ruby API is licensed under the [Apache Licence, Version 2.0][asl2].

[asl2]: http://www.apache.org/licenses/LICENSE-2.0.html
