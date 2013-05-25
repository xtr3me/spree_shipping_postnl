Spree Shipping Postnl
===================

Spree shipping calculator for PostNL
This gem provides a basic shipping calculator for PostNL packages and letters to be send within the Netherlands.

Installation
------------

Add spree_shipping_postnl to your Gemfile:

```ruby
gem 'spree_shipping_postnl'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_shipping_postnl:install
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_shipping_postnl/factories'
```

Copyright (c) 2013 Sjors Baltus, released under the New BSD License
