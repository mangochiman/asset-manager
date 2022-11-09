class Asset < ApplicationRecord
  self.table_name = 'assets'
  self.primary_key = 'asset_id'

  has_many :asset_attachments, :foreign_key => :asset_id
  has_many :asset_activities, :foreign_key => :asset_id
  has_many :asset_service_logs, :foreign_key => :asset_id
  has_many :asset_reservations, :foreign_key => :asset_id
  belongs_to :location, :foreign_key => :location_id
  belongs_to :selection_field, :foreign_key => :condition_id

  belongs_to :asset_type, :foreign_key => :asset_type_id
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

  def checked_out_date
    check_out_date = ""
    checked_out_activity = self.asset_activities.last
    unless checked_out_activity.blank?
      check_out_date = checked_out_activity.checkout_date if checked_out_activity.name.to_s.downcase == "check-out"
    end
    check_out_date
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

  def state
    asset_state = "Available"
    asset_state = "Checked out" if self.checked_out?
    asset_state = "Available" if self.checked_in?
    asset_state = "Maintenance" if self.service_started?
    asset_state = "Retired" if self.retired?
    asset_state
  end

  def complete_all_started_services_except(asset_service_log_id)
    started_services = self.asset_service_logs.where(['asset_service_log_id != ? AND state =?',
                                                      asset_service_log_id, 'Started'])
    started_services.each do |started_service|
      started_service.state = 'Completed'
      started_service.end_date_actual = Time.now
      started_service.save
    end
  end

  def check_in_out_activities
    activities = self.asset_activities.where(['name IN (?)', %w[check-out check-in]])
    activities
  end

  def generate_qr
    require 'barby'
    require 'barby/barcode'
    require 'barby/barcode/qr_code'
    require 'barby/outputter/png_outputter'
    text = self.name
    base64_output = Barby::QrCode.new(text, level: :q, size: 15).to_image.to_data_url
    base64_output
  end

  def asset_type_details
    type_name = self.asset_type.name rescue ""
    type_name
  end

  def location_details
    location_name = self.location.name rescue ""
    location_name
  end

  def condition_details
    condition_name = self.selection_field.field_name rescue ""
    condition_name
  end

  def self.search(key, value)
    assets = []
    key = key.to_s.downcase
    assets = Asset.where(["name LIKE ?", '%' + value + '%']) if key == "name"
    assets = Asset.where(["model LIKE ?", '%' + value + '%']) if key == "model"
    assets = Asset.where(["barcode LIKE ?", '%' + value + '%']) if key == "barcode"
    assets = Asset.joins(:location).where(["locations.name LIKE ?", '%' + value + '%']) if key == "location"
    assets
  end
end

