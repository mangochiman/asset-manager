class AssetStockActivity < ApplicationRecord
  self.table_name = 'asset_stock_activities'
  self.primary_key = 'asset_stock_activity_id'

  belongs_to :asset_stock, :foreign_key => :asset_stock_id
  belongs_to :person, :foreign_key => :person_id,  optional: true
  belongs_to :location, :foreign_key => :location_id,  optional: true

  def asset_details
    asset_stock = self.asset_stock
    asset_info = ""
    asset_info = "#{asset_stock.name}" if !asset_stock.blank?
    asset_info
  end

  def person_details
    (person.first_name.to_s + " " + person.last_name.to_s) rescue ""
  end

  def location_details
    location.name rescue ""
  end
end
