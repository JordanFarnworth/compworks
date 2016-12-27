class CreateServiceLogs < ActiveRecord::Migration
  def change
    create_table :service_logs do |t|
      t.datetime :date
      t.string :length
      t.string :service_preformed
      t.text :notes
      t.string :state
      t.references :companies, index: true

      t.timestamps null: false
    end
  end
end
