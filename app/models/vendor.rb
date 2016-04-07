class Vendor < ActiveRecord::Base
  has_many :purchase_orders, through: :purchase_order_vendors
end
