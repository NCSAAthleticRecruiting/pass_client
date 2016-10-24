# PassClient

The PassClient gem handles connections with the Partner Athlete Search Service (PASS). Using the athlete_... classes, you can perform CRUD operations on athletes within the PASS.

The gem can be configured with an initializer in your Rails project. (See Configuration)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pass_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pass_client

## Usage

Create, update, and delete methods are available from the AthleteCreator, AthleteUpdater, and AthleteDeleter classes, respectively. Each class has a corresponding (!) bang method, e.g. create!, etc. The AthleteGetter class has :get available, without a (!).

## Configuration

This gem must be configured with your auth_id and secret_key to work properly. Create an initializer in your rails project and set the appropriate values on the PassClient. The gem will raise a ConnectionError if you attempt to connect to a signed resource without setting auth_id or secret_key.

```ruby
PassClient.configure do |config|
  config.auth_id = "test_auth_id"
  config.secret_key = "test_secret_key"
end
```

## Gem Signing

The PassClient gem is cryptographically signed to prevent tampering. When installing the gem, you may need to specify the security level.
Use `gem install pass_client -P MediumSecurity` to allow both signed and unsigned gems to be used.

See: http://guides.rubygems.org/security/ for more information about gem signing.
