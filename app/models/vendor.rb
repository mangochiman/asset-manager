require 'write_xlsx'
class Vendor < ApplicationRecord
  self.table_name = 'vendors'
  self.primary_key = 'vendor_id'

  has_many :vendor_attachments, foreign_key: :vendor_id
  has_many :assets, :foreign_key => :vendor_id

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

  def self.work_book
    vendors = Vendor.all
    file = "#{Rails.root}/tmp/vendors.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet
    row_pos = 0
    worksheet.write(row_pos, 0, "Vendor Name")
    worksheet.write(row_pos, 1, "Number")
    worksheet.write(row_pos, 2, "Phone")
    worksheet.write(row_pos, 3, "Website")
    worksheet.write(row_pos, 4, "Contact Name")
    worksheet.write(row_pos, 5, "Email")
    worksheet.write(row_pos, 6, "Address1")
    worksheet.write(row_pos, 7, "Address2")
    worksheet.write(row_pos, 8, "City")
    worksheet.write(row_pos, 9, "State")
    worksheet.write(row_pos, 10, "Postal code")
    worksheet.write(row_pos, 11, "Country")
    worksheet.write(row_pos, 12, "Created_at")

    vendors.each do |vendor|
      row_pos = row_pos + 1
      created_at = vendor.created_at.strftime("%d.%m.%Y")

      worksheet.write(row_pos, 0, vendor.name)
      worksheet.write(row_pos, 1, vendor.number)
      worksheet.write(row_pos, 2, vendor.phone)
      worksheet.write(row_pos, 3, vendor.website)
      worksheet.write(row_pos, 4, vendor.contact_name)
      worksheet.write(row_pos, 5, vendor.email)
      worksheet.write(row_pos, 6, vendor.address1)
      worksheet.write(row_pos, 7, vendor.address2)
      worksheet.write(row_pos, 8, vendor.city)
      worksheet.write(row_pos, 9, vendor.state)
      worksheet.write(row_pos, 10, vendor.postal_code)
      worksheet.write(row_pos, 11, vendor.country)
      worksheet.write(row_pos, 12, created_at)
    end
    # write to file
    workbook.close
    file
  end
end
