class Vendor < ApplicationRecord
  self.table_name = 'vendors'
  self.primary_key = 'vendor_id'

  has_many :vendor_attachments, foreign_key: :vendor_id

  def self.search(key, value)
    vendors = []
    key = key.to_s.downcase
    vendors = Vendor.where(["name LIKE ?", '%' + value + '%']) if key == "name"
    vendors = Vendor.where(["number LIKE ?", '%' + value + '%']) if key == "number"
    vendors = Vendor.where(["email LIKE ?", '%' + value + '%']) if key == "email"
    vendors = Vendor.where(["contact_name LIKE ?", '%' + value + '%']) if key == "contact_name"
    vendors = Vendor.where(["phone LIKE ?", '%' + value + '%']) if key == "phone"
    vendors
  end

end
