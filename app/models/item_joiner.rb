class ItemJoiner < ActiveRecord::Base
  belongs_to :item
  belongs_to :purchase_order
end
