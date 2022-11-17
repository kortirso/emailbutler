# frozen_string_literal: true

Emailbutler::Engine.routes.draw do
  post '/webhooks', to: 'webhooks#create'

  resources :ui, only: %i[index show]
  namespace :ui do
    resources :messages, only: %i[update destroy]
  end
end
