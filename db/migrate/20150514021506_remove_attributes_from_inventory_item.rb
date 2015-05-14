class RemoveAttributesFromInventoryItem < ActiveRecord::Migration
  def change
    remove_column :inventory_items, :attributes, :text
  end
end
