class CreateTrees < ActiveRecord::Migration[5.2]
  def change
    create_table :trees do |t|
      t.text :title
      t.text :content
      t.boolean :toggler

      t.timestamps
    end
  end
end
