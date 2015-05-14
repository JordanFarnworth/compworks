class AddCompanyToInventoryItem < ActiveRecord::Migration
  def change
    add_reference :inventory_items, :company, index: true
    add_foreign_key :inventory_items, :companies
  end
end
