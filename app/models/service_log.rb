class ServiceLog < ActiveRecord::Base
  belongs_to :company

  scope :active, -> {where(state: :active)}
  scope :deleted, -> {where(state: :deleted)}
  scope :paid, -> {where(payment: true)}
  scope :unpaid, -> {where(payment: false)}

  validates :date, presence: true

  before_validation :infer_values

  def infer_values
    self.state ||= :active
  end

  def destroy
   self.state = :deleted
   save
  end

end
