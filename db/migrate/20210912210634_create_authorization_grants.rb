# frozen_string_literal: true

class CreateAuthorizationGrants < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.references :user, foreign_key: true, null: false
      t.string :jti
      t.datetime :expires_at
      t.timestamps
    end

    create_table :authorization_grants do |t|
      t.references :user, foreign_key: true, null: false
      t.string :code_challenge, null: false
      t.string :authorization_code, null: false
      t.datetime :expires_at, null: false
      t.timestamps
    end
  end
end
