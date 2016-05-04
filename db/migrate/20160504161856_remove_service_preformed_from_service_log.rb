class RemoveServicePreformedFromServiceLog < ActiveRecord::Migration
  def change
    remove_column :service_logs, :service_preformed, :string
  end
end
