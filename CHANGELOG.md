# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased
### Added
- saving additional mail params to message
- Webhooks::Receiver class for checking webhooks payload and updating messages
- message params serialization with global id support
- DSL to all the emailbutler goodness
- active record adapter for DSL
- mappers structure with sendgrid example

### Modified
- using emailbutler's DSL everywhere

## [0.1.0] - 2022-09-01
### Added
- Start project
- Emailbutler::Message model for saving sent messages
- Webhooks controller for receiving events
