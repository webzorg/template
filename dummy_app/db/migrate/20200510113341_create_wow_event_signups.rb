# frozen_string_literal: true

class CreateWowEventSignups < ActiveRecord::Migration[6.0]
  def change
    create_table :wow_event_signups do |t|
      t.references :calendar_event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :wow_character, foreign_key: true
      t.string :status, default: "1"
      t.string :comment

      t.timestamps
    end
  end
end
