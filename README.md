# Emailbutler
Simple email tracker for ruby on rails applications.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'emailbutler'
```

And then execute:
```bash
$ bundle install
$ rails g emailbutler:active_record
$ rails db:migrate
```

## Engine configuration

### Initializer

Add this line to config/initializers/emailbutler.rb:

```bash
require 'emailbutler/adapters/active_record'

Emailbutler.configure do |config|
  config.adapter = Emailbutler::Adapters::ActiveRecord.new
end
```

### Routes

Add this line to config/routes.rb

```bash
mount Emailbutler::Engine => '/emailbutler'
```

### Email provider webhooks settings



## Usage

1. Each email sending event will create new record with message params in database.
2. Each receiving webhook will update status of message in database.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
