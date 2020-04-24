# frozen_string_literal: true

Rails.application.routes.draw do
  resources :documents
  resources :public_documents, controller: :index_documents
end
