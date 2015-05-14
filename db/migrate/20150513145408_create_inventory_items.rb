class CreateInventoryItems < ActiveRecord::Migration
  def change
    create_table :inventory_items do |t|
      t.text :attributes
      t.references :company_id, index: true
      t.string :state

      t.timestamps null: false
    end
    add_foreign_key :inventory_items, :company_ids
  end
end
