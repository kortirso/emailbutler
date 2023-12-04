# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.7.4] - 2023-12-04
### Fixed
- skiping verify_authenticity_token

## [0.7.3] - 2023-12-01
### Modified
- inheritance from ActionController::Base

## [0.7.2] - 2023-09-08
### Fixed
- bug with rendering messages with blank send_to attribute

## [0.7.1] - 2023-09-06
### Fixed
- bug with mapping smtp2go payload

## [0.7.0] - 2023-09-06
### Added
- SMTP2GO webhooks integration
- Github Actions integration
- list of skip_before_action for webhooks controller

## [0.6.1] - 2023-07-14
### Modified
- including external dependencies
- gem dependencies
- README

## [0.6.0] - 2023-05-19
### Fixed
- saving uuid for mail message

## [0.5.9] - 2023-05-17
### Fixed
- converting string timestamp

## [0.5.8] - 2023-05-17
### Modified
- modified checking message id

## [0.5.7] - 2023-05-15
### Modified
- DELIVERABILITY_MAPPER

## [0.5.6] - 2023-05-15
### Fixed
- remove pgcrypto from migration

## [0.5.5] - 2023-05-12
### Fixed
- downgrade required pagy version

## [0.5.4] - 2023-05-11
### Fixed
- getting reciepient email in save_emailbutler_message

## [0.5.3] - 2023-05-10
### Fixed
- change base class for Emailbutler::ApplicationController

## [0.5.2] - 2023-05-10
### Modified
- gems versions

## [0.5.1] - 2022-12-24
### Modified
- gems versions

## [0.5.0] - 2022-11-29
### Added
- pagination for show page list
- rendering all messages with status in table

### Modified
- passing arguments for webhooks

## [0.4.0] - 2022-11-17
### Added
- filtering messages by mailer, action and send_to

## [0.3.0] - 2022-10-04
### Added
- UI for rendering dashboard with email tracking statistics
- password protection for UI
- endpoints for resending and deleting messages
- tests for dashboard controller
- tests for messages controller
- deserialization for GID values

## [0.2.3] - 2022-09-16
### Modified
- removed Emailbutler::Event model, optimistic updating messages

### Fixed
- active record adapter's models

## [0.2.2] - 2022-09-12
### Added
- Emailbutler::Event model for saving message events

### Modified
- readme

## [0.2.0] - 2022-09-06
### Added
- saving additional mail params to message
- Webhooks::Receiver class for checking webhooks payload and updating messages
- message params serialization with global id support
- DSL to all the emailbutler goodness
- active record adapter for DSL
- mappers structure with sendgrid example

### Modified
- using emailbutler's DSL everywhere
- readme

## [0.1.0] - 2022-09-01
### Added
- Start project
- Emailbutler::Message model for saving sent messages
- Webhooks controller for receiving events
