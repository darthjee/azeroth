# frozen_string_literal: true

class GamesController < ApplicationController
  include Azeroth::Resourceable
  skip_before_action :verify_authenticity_token

  resource_for :game, except: :delete

  private

  def games
    publisher.games
  end

  def publisher
    @publisher ||= Publisher.find_by(publisher_id)
  end

  def publisher_id
    params.require(:publisher_id)
  end
end
