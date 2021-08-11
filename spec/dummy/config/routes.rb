# frozen_string_literal: true

Rails.application.routes.draw do
  resources :documents
  resources :public_documents, controller: :index_documents
  resources :create_documents, controller: :documents_with_error
  resources :paginated_documents

  resources :publishers, only: %i[create index] do
    resources :games, except: :delete
  end

  resources :pokemon_masters, only: %i[create update] do
    resources :pokemons, only: %i[create update]
  end
end
