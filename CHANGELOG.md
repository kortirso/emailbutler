# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased
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
