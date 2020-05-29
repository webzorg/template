class AddCustomTokensToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :custom_tokens, :json
  end
end
