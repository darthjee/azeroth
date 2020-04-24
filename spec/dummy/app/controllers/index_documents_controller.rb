# frozen_string_literal: true

class IndexDocumentsController < ApplicationController
  include Azeroth::Resourceable

  resource_for :document, only: :index
end
