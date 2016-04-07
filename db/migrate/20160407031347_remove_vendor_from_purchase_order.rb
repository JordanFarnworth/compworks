class RemoveVendorFromPurchaseOrder < ActiveRecord::Migration
  def change
    remove_column :purchase_orders, :vendor, :string
  end
end
