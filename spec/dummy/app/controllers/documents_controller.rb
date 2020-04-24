# frozen_string_literal: true

class DocumentsController < ApplicationController
  include Azeroth::Resourceable

  resource_for :document, except: :index
end
