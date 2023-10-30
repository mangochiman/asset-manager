require 'write_xlsx'
require 'zip'
class AssetStock < ApplicationRecord
  self.table_name = 'asset_stocks'
  self.primary_key = 'asset_stock_id'

  has_many :asset_stock_activities, :foreign_key => :asset_stock_id
  has_many :asset_stock_attachments, :foreign_key => :asset_stock_id
end
