require 'write_xlsx'
require 'zip'
class AssetStock < ApplicationRecord
  self.table_name = 'asset_stocks'
  self.primary_key = 'asset_stock_id'

  has_many :asset_stock_activities, :foreign_key => :asset_stock_id
  has_many :asset_stock_attachments, :foreign_key => :asset_stock_id
  has_many :asset_stock_additions, :foreign_key => :asset_stock_id

  belongs_to :location, :foreign_key => :location_id, optional: true
  belongs_to :selection_field, :foreign_key => :condition_id, optional: true
  belongs_to :vendor, :foreign_key => :vendor_id, optional: true
  belongs_to :asset_type, :foreign_key => :asset_type_id, optional: true
  belongs_to :project, :foreign_key => :project_id, optional: true
  validates_presence_of :name

  validates_uniqueness_of :barcode, allow_blank: true
  validate :asset_quota_validation, :picture_size_validation

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

  def retired?
    retired = false
    retired = true if self.retired.to_i == 1
    retired
  end

  def self.search(key, value)
    asset_stock = []
    key = key.to_s.downcase
    asset_stock = AssetStock.where(["name LIKE ?", '%' + value + '%']) if key == "name"
    asset_stock = AssetStock.where(["model LIKE ?", '%' + value + '%']) if key == "model"
    asset_stock = AssetStock.where(["barcode LIKE ?", '%' + value + '%']) if key == "barcode"
    asset_stock = AssetStock.joins(:location).where(["locations.name LIKE ?", '%' + value + '%']) if key == "location"
    asset_stock
  end

  def asset_quota_validation
    active_system_plan = SystemPlan.where('active =?', 1).last
    assets_quota = active_system_plan.assets_quota
    total_assets = AssetStock.all.count
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

  def active_checkout_activities
    activities = asset_stock_activities.where(['name IN (?)', %w[check-out]]) #TODO
    activities
  end

  def stock_movement
    data = ActiveSupport::HashWithIndifferentAccess.new
    count = 1
    data[count] = {
        activity: "Initial Stock",
        quantity: initial_quantity,
        unit_price: unit_price,
        custody: '',
        created_at: created_at
    }
    asset_stock_additions.each do |asset_stock_addition|
      count += 1
      data[count] = {
          activity: "Add Stock",
          quantity: asset_stock_addition.quantity,
          unit_price: asset_stock_addition.unit_price,
          custody: '',
          created_at: asset_stock_addition.created_at
      }
    end

    asset_stock_activities.each do |asset_stock_activity|
      count += 1
      data[count] = {
          activity: asset_stock_activity.name,
          quantity: asset_stock_activity.quantity,
          unit_price: '',
          custody: asset_stock_activity.person_details,
          created_at: asset_stock_activity.created_at
      }
    end
    data.sort_by{|k,v|v['created_at']}.reverse!
  end

  def total_quantity
    initial_total = initial_quantity.to_i
    checkout_activities = asset_stock_activities.where(['name IN (?)', %w[check-out]])
    checkout_total = 0
    checkout_activities.each do |checkout_activity|
      checkout_total += checkout_activity.quantity.to_i
    end

    checkin_activities = asset_stock_activities.where(['name IN (?)', %w[check-in]])
    checkin_total = 0
    checkin_activities.each do |checkin_activity|
      checkin_total += checkin_activity.quantity.to_i
    end

    additions_total = 0
    asset_stock_additions.each do |asset_stock_addition|
      additions_total += asset_stock_addition.quantity.to_i
    end

    (initial_total + additions_total + checkin_total) - checkout_total
  end

  def checked_out_quantity
    checkout_activities = asset_stock_activities.where(['name IN (?)', %w[check-out]])
    checked_out_total = 0
    checkout_activities.each do |checkout_activity|
      checkout_quantity = checkout_activity.quantity.to_i
      check_in_activities = AssetStockActivity.where(['name IN (?) AND ref_id = ?', %w[check-in],
                                                     checkout_activity.asset_stock_activity_id])
      checkin_total = 0
      check_in_activities.each do |check_in_activity|
        checkin_quantity = check_in_activity.quantity.to_i
        checkin_total += checkin_quantity
      end
      checked_out_total += (checkout_quantity - checkin_total)
    end
    checked_out_total
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
end
