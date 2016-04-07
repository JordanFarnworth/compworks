class AddAttachmentImageToPurchaseOrders < ActiveRecord::Migration
  def self.up
    change_table :purchase_orders do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :purchase_orders, :image
  end
end
