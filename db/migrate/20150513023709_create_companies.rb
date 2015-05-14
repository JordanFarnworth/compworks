class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :network
      t.string :domain
      t.string :antivirus
      t.string :router1
      t.string :router2

      t.timestamps null: false
    end
  end
end
