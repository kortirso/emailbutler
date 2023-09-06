# frozen_string_literal: true

module Emailbutler
  class Configuration
    attr_accessor :adapter, :ui_username, :ui_password, :ui_secured_environments, :skip_before_actions

    def initialize
      @adapter = nil

      # It's required to specify these 3 variables to enable basic auth to UI
      @ui_username = ''
      @ui_password = ''
      # Secured environments variable must directly contains environment names
      @ui_secured_environments = []

      # Skip before_actions from your ApplicationController
      @skip_before_actions = %i[verify_authenticity_token]
    end
  end
end
