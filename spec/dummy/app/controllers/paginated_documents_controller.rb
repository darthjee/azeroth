# frozen_string_literal: true

class PaginatedDocumentsController < ApplicationController
  include Azeroth::Resourceable

  resource_for :document, only: 'index', paginated: true
end
