# frozen_string_literal: true

class CreateWowRaces < ActiveRecord::Migration[6.0]
  def change
    create_table :wow_races do |t|
      t.string :name

      t.timestamps
    end
  end
end
