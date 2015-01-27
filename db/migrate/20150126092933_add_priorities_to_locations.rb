class AddPrioritiesToLocations < ActiveRecord::Migration
  def change
    add_column :spree_stock_locations, :priorities, :string
  end

  def down
    change_table :spree_stock_locations do |t|
      t.remove :priorities
    end
  end
end