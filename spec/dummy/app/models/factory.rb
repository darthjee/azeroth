# frozen_string_literal: true

class Factory < ActiveRecord::Base
  has_many :products, dependent: :destroy
  has_one :main_product, class_name: 'Product', dependent: :destroy
end
