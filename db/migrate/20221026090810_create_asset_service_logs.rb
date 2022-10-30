class CreateAssetServiceLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_service_logs, :primary_key => :asset_service_log_id do |t|
      t.integer :service_item_id
      t.integer :asset_id
      t.date :start_date
      t.date :end_date
      t.text :notes
      t.integer :vendor_id
      t.integer :person_id
      t.timestamps
    end
  end
end
