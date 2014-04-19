class CreateComputers < ActiveRecord::Migration
  def change
    create_table :computers do |t|
      t.string :ip_address
      t.string :mac_address
      t.string :name

      t.timestamps
    end
  end
end
