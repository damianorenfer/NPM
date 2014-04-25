class AddNetmaskCidrToComputer < ActiveRecord::Migration
  def change
    add_column :computers, :netmask_cidr, :integer, default: 24
  end
end
