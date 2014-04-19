class AddPasswordEncryptIvToComputer < ActiveRecord::Migration
  def change
    add_column :computers, :password_encrypt_iv, :string
  end
end
