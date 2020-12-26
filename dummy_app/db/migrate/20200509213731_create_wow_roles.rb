# frozen_string_literal: true

class CreateWowRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :wow_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
