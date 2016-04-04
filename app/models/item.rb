class Item < ActiveRecord::Base
  has_many: :purchase_orders, through: :item_joiners
end
