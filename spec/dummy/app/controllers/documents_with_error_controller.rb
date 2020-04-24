# frozen_string_literal: true

class DocumentsWithErrorController < ApplicationController
  include Azeroth::Resourceable

  resource_for :document,
               only: :create,
               decorator: Document::DecoratorWithError

  resource_for :document,
               only: :update,
               decorator: false
end
