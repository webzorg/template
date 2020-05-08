class CreateCalendarEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :calendar_events do |t|
      t.string :name
      t.text :description
      t.datetime :start_time
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :calendar_events, [:user_id]
  end
end
