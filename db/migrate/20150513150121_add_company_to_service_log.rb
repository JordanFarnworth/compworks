class AddCompanyToServiceLog < ActiveRecord::Migration
  def change
    add_reference :service_logs, :company, index: true
    add_foreign_key :service_logs, :companies
  end
end
