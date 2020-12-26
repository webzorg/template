# frozen_string_literal: true

class AddLastActivityAtToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_activity_at, :datetime
  end
end