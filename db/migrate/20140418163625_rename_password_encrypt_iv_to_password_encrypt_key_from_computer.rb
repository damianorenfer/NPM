class RenamePasswordEncryptIvToPasswordEncryptKeyFromComputer < ActiveRecord::Migration
  def change
    rename_column :computers, :password_encrypt_iv, :password_encrypt_key
  end
end
