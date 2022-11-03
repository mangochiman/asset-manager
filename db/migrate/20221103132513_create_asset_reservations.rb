class CreateAssetReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_reservations, :primary_key => :asset_reservation_id do |t|
      t.integer :asset_id
      t.datetime :start_date
      t.datetime :end_date
      t.integer :person_id
      t.integer :location_id
      t.text :notes
      t.timestamps
    end
  end
end
