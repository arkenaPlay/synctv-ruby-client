# SyncTV Ruby Client

Full client access to [SyncTV's API](http://api.synctv.com/v2/) to use in your gems and Rails apps. The access works based on [ActiveResource](https://github.com/rails/activeresource)

## Installation

Add this line to your application's Gemfile:

    gem 'synctv-ruby-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install synctv-ruby-client

## Usage

Automatically sign all outgoing ActiveResource requests from your app.

``` ruby
    Synctv::Client::Resource.site             = "https://v2-dev.synctv.com"
    Synctv::Client::Resource.client_key       = "<your_client_key_goes_here>"
    Synctv::Client::Resource.device_uid       = "<specify a randmom string>"

    # optionally, specify account information:
    Synctv::Client::Resource.account_email    = "<specify a user account email>"
    Synctv::Client::Resource.account_password = "<specify a user account password>"
    
    Synctv::Client::Resources.Media.find(1) # -> returns first media instance
    
    # for convenience, include the namespace:
    include Synctv::Client::Resources

    # index
    Media.all
    
    # get
    @media = Media.find(1) # -> returns first media instance
    
    # put
    @media.name = "Foobar"
    @media.save
    
    # delete
    @media.delete
    
    # count
    Media.count
```

### Available Resources

The following resources are supported under the `Synctv::Client::Resources` namespace:

``` ruby
    Account
    AccountType
    Bundle
    BundleType
    Container
    ContainerGroup
    ContainerType
    Contributor
    Invoice
    Media
    MediaType
    Ownership
    OwnershipPolicy
    Platform
    PlatformType
    Program
    Schedule
```

### Filters

The easiest way to create a query against a resource is by using the `where` "scope" and the available "Request Fields", example: [Media request](http://api.synctv.com/v2/admin/Api/V2/MediaController.html).

``` ruby
    Media.where(:ids => [1, 2, 3])
    Media.where(:named_like => "foo", :expire_end_date => "2013-02-15T02:06:56Z")

    # or
    Media.where(:named_like => "foo").where(:expire_end_date => "2013-02-15T02:06:56Z")
```

### Scopes

The standard SyncTV resources mixing a set of default scopes that try to mirror scopes as much as in their `ActiveRecord`
counterparts. Scopes can me chained together. By default the following scopes are available in all resources:

``` ruby
    # :order, example:
    Media.order(:id)

    # :reverse_order, example:
    Media.reverse_order

    # :limit, default 25, example:
    Media.limit(50)

    # :offset, default 0, example:
    Media.offset(50)

    # :fields, example:
    Media.fields(:id, :name)

    # :add_fields, example:
    Media.fields(:bundle_ids)

    # :remove_fields, example:
    Media.remove_fields(:id)
    
    # :count, example:
    Media.count
    
```

### Tracking Changes

By default SyncTV resources include the `ActiveModel::Dirty` module that takes care of tracking changes that need to be applied
in `PUT` calls. Example:

``` ruby
    include Synctv::Client::Resources

    @media = Media.find(1)

    @media.name = "Foobar"
    @media.dirty?
    => true
    
    @media.changes
    => {"name"=>["Foo", "Foobar"]}
```

### Adding Authentication to New Resources  ###

SyncTV Ruby client can transparently protect your ActiveResource communications with a
few configuration lines:

``` ruby
    class NewResource < ActiveResource::Base
      with_api_auth(client_key, device_uid, account_email, account_password)
    end
```

or, derive from gem's resource class and add:

``` ruby
    class NewResource < Synctv::Client::Resource
      include Synctv::Client::Scopes
      ...
    end
    
    Synctv::Client::Resource.site             = "https://..."
    Synctv::Client::Resource.client_key       = "upDE..."
    Synctv::Client::Resource.device_uid       = "my_device_uid"
    Synctv::Client::Resource.account_email    = "test@example.com"
    Synctv::Client::Resource.account_password = "mypassword"
    
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
