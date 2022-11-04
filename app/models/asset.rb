class Asset < ApplicationRecord
  self.table_name = 'assets'
  self.primary_key = 'asset_id'

  has_many :asset_attachments, :foreign_key => :asset_id
  has_many :asset_activities, :foreign_key => :asset_id
  has_many :asset_service_logs, :foreign_key => :asset_id

  validates_presence_of :name

  def self.retire_reasons
    %w[Damaged Expired Lost Released Sold Stolen Other]
  end

  def service_started?
    service_started = false
    started_services = self.asset_service_logs.where(["state =?", "started"])
    service_started = true unless started_services.blank?
    service_started
  end

  def checked_out?
    checked_out = false
    checked_out_activity = self.asset_activities.last
    unless checked_out_activity.blank?
      checked_out = true if checked_out_activity.name.to_s.downcase == "check-out"
    end
    checked_out
  end

  def checked_in?
    checked_in = false
    checked_in_activity = self.asset_activities.last
    unless checked_in_activity.blank?
      checked_in = true if checked_in_activity.name.to_s.downcase == "check-in"
    end
    checked_in
  end

  def retired?
    retired = false
    retired = true if self.retired.to_i == 1
    retired
  end

end
