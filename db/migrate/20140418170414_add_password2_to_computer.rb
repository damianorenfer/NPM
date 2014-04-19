class AddPassword2ToComputer < ActiveRecord::Migration
  def change
    add_column :computers, :password, :string
  end
end
