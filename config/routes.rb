# frozen_string_literal: true

Emailbutler::Engine.routes.draw do
  post '/webhooks', to: 'webhooks#create'

  namespace :ui do
    resources :dashboard, only: %i[index show]
  end
end
