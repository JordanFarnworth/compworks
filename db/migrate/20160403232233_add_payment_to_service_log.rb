class AddPaymentToServiceLog < ActiveRecord::Migration
  def change
    add_column :service_logs, :payment, :boolean
  end
end
