# frozen_string_literal: true

module Emailbutler
  class Configuration
    attr_accessor :adapter, :ui_username, :ui_password, :ui_secured_environments

    def initialize
      @adapter = nil

      # It's required to specify these 3 variables to enable basic auth to UI
      @ui_username = ''
      @ui_password = ''
      # Secured environments variable must directly contains environment names
      @ui_secured_environments = []
    end
  end
end
