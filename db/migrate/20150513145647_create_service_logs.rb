class CreateServiceLogs < ActiveRecord::Migration
  def change
    create_table :service_logs do |t|
      t.datetime :date
      t.string :length
      t.string :service_preformed
      t.text :notes
      t.string :state
      t.references :company_id, index: true

      t.timestamps null: false
    end
    add_foreign_key :service_logs, :company_ids
  end
end
