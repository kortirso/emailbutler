# frozen_string_literal: true

module AuthHelper
  def http_login
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials('username', 'password')
  end
end
