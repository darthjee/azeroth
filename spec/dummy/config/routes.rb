# frozen_string_literal: true

Rails.application.routes.draw do
  resources :documents
  resources :public_documents, controller: :index_documents
  resources :create_documents, controller: :documents_with_error
end
