require 'write_xlsx'
class Group < ApplicationRecord
  self.table_name = 'groups'
  self.primary_key = 'group_id'

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.work_book
    groups = Group.all
    file = "#{Rails.root}/tmp/groups.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet
    row_pos = 0
    worksheet.write(row_pos, 0, "Group Name")
    worksheet.write(row_pos, 1, "created_at")

    groups.each do |group|
      row_pos = row_pos + 1
      created_at = group.created_at.strftime("%d.%m.%Y")
      worksheet.write(row_pos, 0, group.name)
      worksheet.write(row_pos, 1, created_at)
    end
    # write to file
    workbook.close
    file
  end

end
