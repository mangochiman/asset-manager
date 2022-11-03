class CreateAssetServiceSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_service_schedules, :primary_key => :asset_service_schedule_id do |t|
      t.integer :service_item_id
      t.integer :asset_id
      t.datetime :start_date
      t.datetime :end_date
      t.integer :service_indefinite
      t.string :performed_by
      t.integer :vendor_id
      t.integer :person_id
      t.text :notes
      t.timestamps
    end
  end
end
