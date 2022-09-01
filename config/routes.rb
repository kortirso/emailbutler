# frozen_string_literal: true

Emailbutler::Engine.routes.draw do
  post '/webhooks', to: 'webhooks#create'
end
