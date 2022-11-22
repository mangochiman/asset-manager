require 'write_xlsx'
class AssetType < ApplicationRecord
  self.table_name = 'asset_types'
  self.primary_key = 'asset_type_id'

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.work_book
    asset_types = AssetType.all
    file = "#{Rails.root}/tmp/asset_types.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet
    row_pos = 0
    worksheet.write(row_pos, 0, "Asset Type Name")
    worksheet.write(row_pos, 1, "created_at")

    asset_types.each do |asset_type|
      row_pos = row_pos + 1
      created_at = asset_type.created_at.strftime("%d.%m.%Y")
      worksheet.write(row_pos, 0, asset_type.name)
      worksheet.write(row_pos, 1, created_at)
    end
    # write to file
    workbook.close
    file
  end

end
