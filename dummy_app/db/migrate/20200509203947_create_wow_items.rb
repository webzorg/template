class CreateWowItems < ActiveRecord::Migration[6.0]
  def change
    create_table :wow_items do |t|
      t.string :name
    end
  end
end
