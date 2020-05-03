# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :documents, force: true do |t|
    t.string   :name
    t.string   :reference
  end

  create_table :users, force: true do |t|
    t.string :name
    t.string :email
    t.string :reference
  end

  create_table :factories, force: true do |t|
    t.string :name
  end

  create_table :products, force: true do |t|
    t.integer :factory_id
    t.string :name
  end
end
