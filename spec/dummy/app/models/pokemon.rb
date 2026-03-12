# frozen_string_literal: true

class Pokemon < ApplicationRecord
  belongs_to :pokemon_master
  has_one :previous_form,
          class_name: 'Pokemon',
          foreign_key: :previous_form_id,
          inverse_of: :next_form,
          dependent: :destroy
  has_one :next_form,
          class_name: 'Pokemon',
          dependent: :destroy,
          inverse_of: :previous_form
end
