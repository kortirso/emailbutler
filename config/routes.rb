# frozen_string_literal: true

Emailbutler::Engine.routes.draw do
  post '/webhooks', to: 'webhooks#create'

  namespace :ui do
    resources :dashboard, only: %i[index show]
    resources :messages, only: %i[update destroy]
  end
end
