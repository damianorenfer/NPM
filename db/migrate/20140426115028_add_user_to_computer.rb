class AddUserToComputer < ActiveRecord::Migration
  def change
    add_reference :computers, :user, index: true
  end
end
