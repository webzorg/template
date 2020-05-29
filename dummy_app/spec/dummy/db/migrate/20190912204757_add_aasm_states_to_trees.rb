class AddAasmStatesToTrees < ActiveRecord::Migration[5.2]
  def change
    add_column :trees, :aasm_state, :string
  end
end
