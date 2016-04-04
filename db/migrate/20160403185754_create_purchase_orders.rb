class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.integer :po_number
      t.string :vendor
      t.references :company, index: true
      t.text :items

      t.timestamps null: false
    end
    add_foreign_key :purchase_orders, :companies
  end
end
