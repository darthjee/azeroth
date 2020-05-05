# frozen_string_literal: true

class GamesController < ApplicationController
  include Azeroth::Resourceable

  resource_for :game, except: :delete
end
