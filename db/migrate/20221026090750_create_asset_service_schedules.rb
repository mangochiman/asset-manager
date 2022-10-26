class CreateAssetServiceSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_service_schedules, :primary_key => :asset_service_schedule_id do |t|
      t.integer :service_item_id
      t.integer :asset_id
      t.date :start_date
      t.date :end_date
      t.string :frequency
      t.string :notes
      t.timestamps
    end
  end
end
