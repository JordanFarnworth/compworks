class PurchaseOrderVendor < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :purchase_order
end
