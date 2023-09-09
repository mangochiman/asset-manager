class CreateAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :assets, :primary_key => :asset_id do |t|
      t.string :name
      t.string :barcode
      t.integer :asset_type_id
      t.integer :project_id
      t.integer :status_id
      t.integer :location_id
      t.integer :condition_id
      t.integer :vendor_id
      t.string :serial_number
      t.string :manufacturer
      t.string :brand
      t.string :model
      t.decimal :unit_price
      t.date :date_purchased
      t.string :order_number
      t.string :account_code
      t.date :warranty_end
      t.text :notes
      t.string :photo_url
      t.integer :retired
      t.string :retire_reason
      t.date :date_retired
      t.integer :retired_by
      t.string :retire_comments
      t.timestamps
    end
  end
end
