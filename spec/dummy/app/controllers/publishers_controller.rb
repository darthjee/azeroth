# frozen_string_literal: true

class PublishersController < ApplicationController
  include Azeroth::Resourceable
  skip_before_action :verify_authenticity_token

  resource_for :publisher, only: %i[create index]
end
