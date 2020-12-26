# frozen_string_literal: true

class CreateWowCharacters < ActiveRecord::Migration[6.0]
  def change
    create_table :wow_characters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :wow_class
      t.references :wow_race
      t.references :wow_role

      t.string :priority
      t.integer :level
      t.string :name
      t.integer :head
      t.integer :neck
      t.integer :shoulder
      t.integer :back
      t.integer :chest
      t.integer :wrist
      t.integer :hands
      t.integer :waist
      t.integer :legs
      t.integer :feet
      t.integer :finger_1
      t.integer :finger_2
      t.integer :trinket_1
      t.integer :trinket_2
      t.integer :main_hand
      t.integer :off_hand
      t.integer :ranged_relic

      t.timestamps
    end
  end
end
