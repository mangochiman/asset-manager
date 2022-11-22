require 'write_xlsx'
class Location < ApplicationRecord
  self.table_name = 'locations'
  self.primary_key = 'location_id'

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.work_book
    locations = Location.all
    file = "#{Rails.root}/tmp/locations.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet
    row_pos = 0
    worksheet.write(row_pos, 0, "Location Name")
    worksheet.write(row_pos, 1, "created_at")

    locations.each do |location|
      row_pos = row_pos + 1
      created_at = location.created_at.strftime("%d.%m.%Y")
      worksheet.write(row_pos, 0, location.name)
      worksheet.write(row_pos, 1, created_at)
    end
    # write to file
    workbook.close
    file
  end
end
