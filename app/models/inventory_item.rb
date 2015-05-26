class InventoryItem < ActiveRecord::Base
  belongs_to :company

  scope :active, -> {where(state: :active)}
  scope :deleted, -> {where(state: :deleted)}

  validates :features, presence: true

  after_validation :create_features
  before_validation :infer_values

  serialize :features, Hash

  def infer_values
    self.state ||= :active
  end

  def create_features()
    unless self.features?
      self.features[:computer_name] ||= ""
      self.features[:processor] ||= ""
      self.features[:ram] ||= ""
      self.features[:hard_drive] ||= ""
      self.features[:operating_system] ||= ""
      self.features[:log_me_in] ||= true
    end
  end

  def destroy
   self.state = :deleted
   save
  end

end
