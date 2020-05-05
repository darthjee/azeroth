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

  create_table :pokemon_masters, force: true do |t|
    t.string :first_name, null: false
    t.string :last_name
    t.integer :age, null: false
  end

  create_table :pokemons, force: true do |t|
    t.string :name, null: false
    t.string :nickname
    t.integer :pokemon_master_id
    t.boolean :favorite
    t.integer :previous_form_id
    t.index %i[pokemon_master_id favorite], unique: true
  end

  add_foreign_key 'pokemons', 'pokemon_masters'
end
