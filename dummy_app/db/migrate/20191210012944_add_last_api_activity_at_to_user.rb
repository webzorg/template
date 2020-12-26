# frozen_string_literal: true

class AddLastApiActivityAtToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_api_activity_at, :datetime
  end
end
