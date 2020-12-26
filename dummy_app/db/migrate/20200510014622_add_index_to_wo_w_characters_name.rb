# frozen_string_literal: true

class AddIndexToWoWCharactersName < ActiveRecord::Migration[6.0]
  def change
    add_index :wow_characters, :name
  end
end
