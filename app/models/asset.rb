require 'write_xlsx'
require 'zip'

class Asset < ApplicationRecord
  self.table_name = 'assets'
  self.primary_key = 'asset_id'

  has_many :asset_attachments, :foreign_key => :asset_id
  has_many :asset_activities, :foreign_key => :asset_id
  has_many :asset_service_logs, :foreign_key => :asset_id
  has_many :asset_reservations, :foreign_key => :asset_id

  belongs_to :location, :foreign_key => :location_id, optional: true
  belongs_to :selection_field, :foreign_key => :condition_id, optional: true
  belongs_to :vendor, :foreign_key => :vendor_id, optional: true
  belongs_to :asset_type, :foreign_key => :asset_type_id, optional: true
  belongs_to :project, :foreign_key => :project_id, optional: true
  validates_presence_of :name

  validate :asset_quota_validation, :picture_size_validation

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

  def self.checked_out
    assets = []
    Asset.all.each do |asset|
      assets << asset if asset.state.to_s.match(/out/i)
    end
    assets
  end

  def self.maintenance_assets
    assets = []
    Asset.all.each do |asset|
      assets << asset if asset.state.to_s.match(/Maintenance/i)
    end
    assets
  end

  def self.available_assets
    assets = []
    Asset.all.each do |asset|
      assets << asset if asset.state.to_s.match(/Available/i)
    end
    assets
  end

  def checked_out_date
    check_out_date = ""
    checked_out_activity = self.asset_activities.last
    unless checked_out_activity.blank?
      check_out_date = checked_out_activity.checkout_date if checked_out_activity.name.to_s.downcase == "check-out"
    end
    check_out_date
  end

  def return_on_date
    return_date = ""
    checked_out_activity = self.asset_activities.last
    unless checked_out_activity.blank?
      return_date = checked_out_activity.return_on if checked_out_activity.name.to_s.downcase == "check-out"
    end
    return_date
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

  def self.retired_assets
    Asset.where(["retired = 1"])
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

  def vendor_details
    vendor_name = self.vendor.name rescue ""
    vendor_name
  end

  def condition_details
    condition_name = self.selection_field.field_name rescue ""
    condition_name
  end

  def project_details
    project_name = self.project.name rescue ""
    project_name
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

  def self.work_book
    assets = Asset.all
    file = "#{Rails.root}/tmp/assets.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet
    row_pos = 0
    worksheet.write(row_pos, 0, "Asset Name")
    worksheet.write(row_pos, 1, "Asset Barcode")
    worksheet.write(row_pos, 2, "asset_type")
    worksheet.write(row_pos, 3, "location")
    worksheet.write(row_pos, 4, "condition")
    worksheet.write(row_pos, 5, "vendor")
    worksheet.write(row_pos, 6, "serial_number")
    worksheet.write(row_pos, 7, "manufacturer")
    worksheet.write(row_pos, 8, "brand")
    worksheet.write(row_pos, 9, "model")
    worksheet.write(row_pos, 10, "unit_price")
    worksheet.write(row_pos, 11, "date_purchased")
    worksheet.write(row_pos, 12, "order_number")
    worksheet.write(row_pos, 13, "account_code")
    worksheet.write(row_pos, 14, "warranty_end")
    worksheet.write(row_pos, 15, "notes")
    worksheet.write(row_pos, 16, "retired")
    worksheet.write(row_pos, 17, "retire_reason")
    worksheet.write(row_pos, 19, "date_retired")
    worksheet.write(row_pos, 19, "retired_by")
    worksheet.write(row_pos, 20, "retire_comments")
    worksheet.write(row_pos, 21, "created_at")
    worksheet.write(row_pos, 22, "project")

    assets.each do |asset|
      row_pos = row_pos + 1
      created_at = asset.created_at.strftime("%d.%m.%Y")
      worksheet.write(row_pos, 0, asset.name)
      worksheet.write(row_pos, 1, asset.barcode)
      worksheet.write(row_pos, 2, asset.asset_type_details)
      worksheet.write(row_pos, 3, asset.location_details)
      worksheet.write(row_pos, 4, asset.condition_details)
      worksheet.write(row_pos, 5, asset.vendor_details)
      worksheet.write(row_pos, 6, asset.serial_number)
      worksheet.write(row_pos, 7, asset.manufacturer)
      worksheet.write(row_pos, 8, asset.brand)
      worksheet.write(row_pos, 9, asset.model)
      worksheet.write(row_pos, 10, asset.unit_price)
      worksheet.write(row_pos, 11, asset.date_purchased)
      worksheet.write(row_pos, 12, asset.order_number)
      worksheet.write(row_pos, 13, asset.account_code)
      worksheet.write(row_pos, 14, asset.warranty_end)
      worksheet.write(row_pos, 15, asset.notes)
      worksheet.write(row_pos, 16, asset.retired)
      worksheet.write(row_pos, 17, asset.retire_reason)
      worksheet.write(row_pos, 19, asset.date_retired)
      worksheet.write(row_pos, 19, asset.retired_by)
      worksheet.write(row_pos, 20, asset.retire_comments)
      worksheet.write(row_pos, 21, created_at)
      worksheet.write(row_pos, 22, asset.project_details)
    end
    # write to file
    workbook.close
    file
  end

  def self.zip_files(files, zip_name)
    zip_path = "#{Rails.root}/tmp/#{zip_name}"
    File.delete(zip_path) if File.exist?(zip_path)
    Zip::File.open(zip_path, Zip::File::CREATE) do |zip_file|
      files.each do |filename, file_path|
        zip_file.add(filename, file_path)
      end
    end
    zip_path
  end

  def asset_quota_validation
    active_system_plan = SystemPlan.where('active =?', 1).last
    assets_quota = active_system_plan.assets_quota
    total_assets = Asset.all.count
    if total_assets > assets_quota
      errors.add(:base, "Your current subscription allows maximum of <b>#{assets_quota}</b> assets. Please upgrade your account")
    end
  end

  def picture_size_validation
    unless self.photo_url.blank?
      file_path = Rails.root.to_s + '/public' + self.photo_url.to_s
      uploaded_file_size_in_bytes = File.size(file_path) rescue 1
      uploaded_file_size_in_mb =  uploaded_file_size_in_bytes.to_f/( 1024 * 1024) #from bytes to MB
      max_file_size_quota_mb = User.max_asset_photo_mb

      if uploaded_file_size_in_mb > max_file_size_quota_mb
        File.delete(file_path) if File.exist?(file_path) && !self.photo_url.blank?
        errors.add(:base, "Pictures above <b>#{max_file_size_quota_mb} MB</b> can not be uploaded")
      end
    end
  end

end

