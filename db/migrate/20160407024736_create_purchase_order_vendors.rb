class CreatePurchaseOrderVendors < ActiveRecord::Migration
  def change
    create_table :purchase_order_vendors do |t|
      t.references :vendor, index: true
      t.references :purchase_order, index: true

      t.timestamps null: false
    end
    add_foreign_key :purchase_order_vendors, :vendors
    add_foreign_key :purchase_order_vendors, :purchase_orders
  end
end
