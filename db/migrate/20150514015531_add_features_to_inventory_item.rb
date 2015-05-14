class AddFeaturesToInventoryItem < ActiveRecord::Migration
  def change
    add_column :inventory_items, :features, :text
  end
end
