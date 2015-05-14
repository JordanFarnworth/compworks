class RemoveCompanyIdIdFromInventoryItem < ActiveRecord::Migration
  def change
    remove_column :inventory_items, :company_id_id, :integer
    remove_column :service_logs, :company_id_id, :integer
  end
end
