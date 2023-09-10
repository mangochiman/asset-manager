class AssetActivity < ApplicationRecord
  self.table_name = 'asset_activities'
  self.primary_key = 'asset_activity_id'

  belongs_to :asset, :foreign_key => :asset_id
  belongs_to :person, :foreign_key => :person_id,  optional: true
  belongs_to :location, :foreign_key => :location_id,  optional: true

  def self.last_activity(asset_id)
    last_activity = AssetActivity.where(['asset_id =?', asset_id]).last
    last_activity
  end

  def asset_details
    asset = self.asset
    asset_name = asset.name rescue ""
    asset_name
  end

  def person_details
    (person.first_name.to_s + " " + person.last_name.to_s) rescue ""
  end

  def location_details
    location.name rescue ""
  end

end
