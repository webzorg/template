class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[6.0]
  def change
    ## Tokens
    add_column :users, :tokens, :json
  end
end

