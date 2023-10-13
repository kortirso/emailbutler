# Emailbutler
Simple email tracker for Ruby on Rails applications.
Emailbutler allows you to track delivery status of emails sent by your app through Sendgrid and/or SMTP2GO.

There are situations when you need to check whether a certain letter or certain type of letters was successfully sent from the application, and through the UI of some providers you can try to find such a letter by the recipient or the subject of the letter, but sometimes it's not enough.

Emailbutler allows you to monitor the sending of letters, collects notifications from providers about the success of delivery and adds an UI for monitoring deliveries with filtering by recipients, mailers and actions.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'emailbutler'
gem 'pagy'
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
  config.skip_before_actions = %i[verify_authenticity_token]
end
```

### Routes

Add this line to config/routes.rb
```ruby
mount Emailbutler::Engine => '/emailbutler'
```

#### Custom routes

If you need some custom behaviour you can specify your own route and use custom controller, something like

```ruby
class SendgridController < ApplicationController
  skip_before_action :basic_authentication
  skip_before_action :verify_authenticity_token

  def create
    ... you can add some logic here

    ::Emailbutler::Webhooks::Receiver.call(
      user_agent: request.headers['HTTP_USER_AGENT'],
      payload: receiver_params.to_h
    )

    head :ok
  end

  private

  def receiver_params
    params.permit(
      'event', 'sendtime', 'message-id',
      '_json' => %w[event timestamp smtp-id sg_message_id]
    )
  end
end
```

### UI styles

For adding styles for UI you need to add this line to assets/config/manifest.js
```js
//= link emailbutler.css
```

Or in some cases you can specify it in assets/javascript/application.js

```js
//= require emailbutler_manifest
````

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

#### SMTP2GO

- go to [Mail settings](https://app-eu.smtp2go.com/settings/webhooks),
- turn on Webhooks,
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
