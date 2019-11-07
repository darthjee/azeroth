# frozen_string_literal: true

Rails.application.routes.draw do
  resources :documents, only: %i[index show create update new]
end
