# Emailbutler
Simple email tracker for Ruby on Rails applications.
Emailbutler allows you to track delivery status of emails sent by your app.

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

Add configuration line to config/initializers/emailbutler.rb:

#### ActiveRecord

```ruby
require 'emailbutler/adapters/active_record'

Emailbutler.configure do |config|
  config.adapter = Emailbutler::Adapters::ActiveRecord.new
end
```

### Routes

Add this line to config/routes.rb
```ruby
mount Emailbutler::Engine => '/emailbutler'
```

### Mailers

Update you application mailer
```ruby
class ApplicationMailer < ActionMailer::Base
  include Emailbutler::Mailers::Helpers
end
```

### Email provider webhooks settings

#### Sendgrid

- go to [Mail settings](https://app.sendgrid.com/settings/mail_settings),
- turn on Event Webhook,
- in the HTTP POST URL field, paste the URL to webhook controller of your app,
- select all deliverability data,
- save settings.

## Usage

1. Each event with sending email will create new record with message params in database.
2. Each webhook event will update status of message in database.

### UI

Emailbutler provides UI with rendering email tracking statistics - /emailbutler/ui/dashboard.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
