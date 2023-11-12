class CreateAssetStockAdditions < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_stock_additions, :primary_key => :asset_stock_addition_id do |t|
      t.integer :asset_stock_id
      t.integer :quantity
      t.decimal :unit_price
      t.decimal :total_price
      t.integer :person_id
      t.integer :location_id
      t.integer :vendor_id
      t.text :notes
      t.timestamps
    end
  end
end
