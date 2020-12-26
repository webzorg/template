# frozen_string_literal: true

class AddIndexToWoWItemsName < ActiveRecord::Migration[6.0]
  def change
    add_index :wow_items, :name
  end
end
