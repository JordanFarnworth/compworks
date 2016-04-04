class CreateItemJoiners < ActiveRecord::Migration
  def change
    create_table :item_joiners do |t|
      t.references :item, index: true
      t.references :purchase_order, index: true

      t.timestamps null: false
    end
    add_foreign_key :item_joiners, :items
  end
end
