class AssetActivity < ApplicationRecord
  self.table_name = 'asset_activities'
  self.primary_key = 'asset_activity_id'

  def self.last_activity(asset_id)
    last_activity = AssetActivity.where(['asset_id =?', asset_id]).last
    last_activity
  end
end
