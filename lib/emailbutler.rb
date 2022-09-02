# frozen_string_literal: true

require 'emailbutler/version'
require 'emailbutler/engine'

module Emailbutler
  module Mailers
    autoload :Helpers, 'emailbutler/mailers/helpers'
  end

  module Webhooks
    autoload :Receiver, 'emailbutler/webhooks/receiver'
  end
end
