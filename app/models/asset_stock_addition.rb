class AssetStockAddition < ApplicationRecord
  self.table_name = 'asset_stock_additions'
  self.primary_key = 'asset_stock_addition_id'

  belongs_to :asset_stock, :foreign_key => :asset_stock_id
  belongs_to :person, :foreign_key => :person_id,  optional: true
  belongs_to :location, :foreign_key => :location_id,  optional: true
  belongs_to :vendor, :foreign_key => :vendor_id,  optional: true

end
