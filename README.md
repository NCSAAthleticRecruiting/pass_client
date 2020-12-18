# PassClient

The PassClient gem handles connections with the Partner Athlete Search Service (PASS). Using the athlete\_... classes, you can perform CRUD operations on athletes within the PASS.

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

### Search

You can search via GET or POST requests, depending on the size of your search terms. The list of available search terms can be found [here](https://github.com/NCSAAthleticRecruiting/activity_umbrella/blob/master/apps/partner_athlete_search/Elasticsearch.md)

ex:

```ruby
search_terms = { sport_id: 101 }

get_client = PassClient::Athlete::Search(search_terms: search_terms)
response = client.get

post_client = PassClient::Athlete::PostSearch(search_terms: search_terms)
response = post_client.post
```

## Configuration

This gem must be configured with your auth_id and secret_key to work properly. Create an initializer in your rails project and set the appropriate values on the PassClient. The gem will raise a ConnectionError if you attempt to connect to a signed resource without setting auth_id or secret_key.

```ruby
PassClient.configure do |config|
  config.auth_id = "test_auth_id"
  config.secret_key = "test_secret_key"
end
```

## Gem Signing

The PassClient gem is not cryptographically signed, so when installing the gem, you may need to specify the security level.
Use `gem install pass_client -P MediumSecurity` to allow both signed and unsigned gems to be used.

See: http://guides.rubygems.org/security/ for more information about gem signing.

### Ruby Style Guide

Ruby Style guides for NCSA is defined at https://ncsasports.atlassian.net/wiki/spaces/DEV/pages/704053308/Ruby+Style+Guide

ncsa-vulcan is a ruby gem to enforce our style guide. After changes are made, verify styles by using `vulcan`. The build will run the code base via `vulcan -a` and will not pass until all files are compliant.

It's recommended to enable Vulcan during the pre-commit phase. We must run: `git config core.hooksPath git_hooks`
