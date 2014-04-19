class AddUsernameToComputer < ActiveRecord::Migration
  def change
    add_column :computers, :username, :string
  end
end
