class PurchaseOrder < ActiveRecord::Base
  belongs_to :company
  has_many :items
  has_many :item_joiners
  has_many :items, through: :item_joiners
  has_many :vendors
  has_many :purchase_order_vendors
  has_many :vendors, through: :purchase_order_vendors
  after_create :set_po_number!

  scope :paid, -> {where(payment: :true)}
  scope :unpaid, -> {where(payment: :false)}

  has_attached_file :image, styles: { large: "400x600>", medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  private
  def set_po_number!
    self.po_number ||= self.id + 16040
    self.save!
  end
end
