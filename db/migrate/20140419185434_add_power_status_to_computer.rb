class AddPowerStatusToComputer < ActiveRecord::Migration
  def change
    add_column :computers, :power_status, :integer, default: 0
  end
end
