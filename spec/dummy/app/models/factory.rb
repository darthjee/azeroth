# frozen_string_literal: true

class Factory < ActiveRecord::Base
  has_many :products
  has_one :main_product, class_name: 'Product'
end
