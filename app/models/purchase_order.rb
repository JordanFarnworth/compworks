class PurchaseOrder < ActiveRecord::Base
  belongs_to :company
  has_many :items, through: :item_joiners
  has_one :vendor
  before_create :set_po_number

  private
  def set_po_number
    self.po_number ||= self.id + 1600
  end
end
