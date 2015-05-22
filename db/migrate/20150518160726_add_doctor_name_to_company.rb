class AddDoctorNameToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :doctor_name, :string
  end
end
