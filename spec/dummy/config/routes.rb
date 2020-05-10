# frozen_string_literal: true

Rails.application.routes.draw do
  resources :documents
  resources :public_documents, controller: :index_documents
  resources :create_documents, controller: :documents_with_error

  resources :publishers, only: %i[create index] do
    resources :games, except: :delete
  end

  resources :pokemon_masters, only: [] do
    resources :pokemons, only: [:create, :update]
  end
end
