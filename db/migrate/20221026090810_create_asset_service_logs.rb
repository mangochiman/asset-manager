class CreateAssetServiceLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_service_logs, :primary_key => :asset_service_log_id do |t|
      t.integer :service_item_id
      t.integer :asset_id
      t.datetime :start_date_actual
      t.datetime :start_date_expected
      t.datetime :end_date_actual
      t.datetime :end_date_expected
      t.integer :service_indefinite
      t.integer :available_on_date
      t.string :state
      t.string :performed_by
      t.integer :vendor_id
      t.integer :person_id
      t.text :notes
      t.decimal :cost
      t.timestamps
    end
  end
end
