class AddPaymentToPurchaseOrder < ActiveRecord::Migration
  def change
    add_column :purchase_orders, :payment, :boolean
  end
end
