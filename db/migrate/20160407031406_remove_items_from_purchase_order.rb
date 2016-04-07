class RemoveItemsFromPurchaseOrder < ActiveRecord::Migration
  def change
    remove_column :purchase_orders, :items, :text
  end
end
