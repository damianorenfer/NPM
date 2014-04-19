class AddPasswordToComputer < ActiveRecord::Migration
  def change
    add_column :computers, :password, :string
  end
end
