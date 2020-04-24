# frozen_string_literal: true

class DocumentsWithErrorController < ApplicationController
  include Azeroth::Resourceable

  resource_for :document,
    only: [:create, :update],
    decorator: Document::DecoratorWithError
end

