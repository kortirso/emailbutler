# frozen_string_literal: true

Rails.application.routes.draw do
  mount Emailbutler::Engine => '/emailbutler'
end
