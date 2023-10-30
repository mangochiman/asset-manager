class CreateAssetStockActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_stock_activities, :primary_key => :asset_stock_activity_id do |t|
      t.integer :asset_stock_id
      t.string :name
      t.datetime :checkout_date
      t.integer :checkout_indefinite
      t.datetime :return_on
      t.datetime :checkin_date
      t.integer :person_id
      t.integer :location_id
      t.text :notes
      t.timestamps
    end
  end
end
