# frozen_string_literal: true

class PublishersController < ApplicationController
  include Azeroth::Resourceable

  resource_for :game, only: %i[create index]
end
