class Company < ActiveRecord::Base
  has_many :inventory_items
  has_many :service_logs
  has_many :purchase_orders

  scope :active, -> {where(state: :active)}
  scope :deleted, -> {where(state: :deleted)}

  validates :network, presence: true
  validates :name, presence: true
  validates :domain, presence: true
  validates :antivirus, presence: true
  validates :router1, presence: true
  validates :router2, presence: true
  validates :name, uniqueness: true

  before_validation :infer_values

  def infer_values
      self.state ||= :active
  end

  def active?
    state == 'active'
  end

  def destroy
    self.state = 'deleted'
    save
  end

#for backend testing
  def add_service_log
    sl = ServiceLog.create(company: self)
    self.service_logs << sl
  end

  def add_inventory_item
    it = InventoryItem.create(company: self)
    self.inventory_items << it
  end

end
