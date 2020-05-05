# frozen_string_literal: true

class Pokemon < ActiveRecord::Base
  belongs_to :pokemon_master
  has_one :previous_form,
          class_name: 'Pokemon',
          foreign_key: :previous_form_id
end
