class RemovePasswordFromComputer < ActiveRecord::Migration
  def change
    remove_column :computers, :password, :binary
  end
end
