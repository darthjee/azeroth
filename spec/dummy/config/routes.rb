# frozen_string_literal: true

Rails.application.routes.draw do
  resources :documents, only: :index
end
