# frozen_string_literal: true

Emailbutler::Engine.routes.draw do
  post '/webhooks/:provider', to: 'webhooks#create' if Emailbutler.configuration.providers.any?

  resources :ui, only: %i[index show]
  namespace :ui do
    resources :messages, only: %i[update destroy]
  end
end
