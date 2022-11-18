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
  config.ui_username = 'username'
  config.ui_password = 'password'
  config.ui_secured_environments = ['production']
end
```

### Routes

Add this line to config/routes.rb
```ruby
mount Emailbutler::Engine => '/emailbutler'
```

### UI styles

For adding styles for UI you need to add this line to assets/config/manifest.js
```js
//= link emailbutler.css
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

Emailbutler provides UI with rendering email tracking statistics - /emailbutler/ui, with opportunity to search, resend and/or destroy emails.

<img width="1463" alt="ui_index" src="https://user-images.githubusercontent.com/6195394/202743189-19d1845d-7991-494f-93c1-0dd92b0b5dac.png">

<img width="1461" alt="ui_show" src="https://user-images.githubusercontent.com/6195394/202743225-b0ba0ca2-d373-428c-973d-5ec4566a3784.png">


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
