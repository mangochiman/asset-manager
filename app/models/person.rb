require 'write_xlsx'
class Person < ApplicationRecord
  self.table_name = 'people'
  self.primary_key = 'person_id'

  has_many :person_attachments, :foreign_key => :person_id
  has_one :user

  belongs_to :location, :foreign_key => :location_id,  :optional => true
  belongs_to :group, :foreign_key => :group_id,  :optional => true

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_uniqueness_of :phone

  def self.search(key, value)
    people = []
    key = key.to_s.downcase
    people = Person.where(["first_name LIKE ?", '%' + value + '%']) if key == "first_name"
    people = Person.where(["last_name LIKE ?", '%' + value + '%']) if key == "last_name"
    people = Person.where(["email LIKE ?", '%' + value + '%']) if key == "email"
    people = Person.where(["barcode LIKE ?", '%' + value + '%']) if key == "personnel_number"
    people = Person.where(["phone LIKE ?", '%' + value + '%']) if key == "phone_number"
    people
  end

  def self.work_book
    people = Person.all
    file = "#{Rails.root}/tmp/people.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet
    row_pos = 0
    worksheet.write(row_pos, 0, "first_name")
    worksheet.write(row_pos, 1, "last_name")
    worksheet.write(row_pos, 2, "barcode")
    worksheet.write(row_pos, 3, "location")
    worksheet.write(row_pos, 4, "group")
    worksheet.write(row_pos, 5, "email")
    worksheet.write(row_pos, 6, "phone")
    worksheet.write(row_pos, 7, "role")
    worksheet.write(row_pos, 8, "created_at")

    people.each do |person|
      row_pos = row_pos + 1
      created_at = person.created_at.strftime("%d.%m.%Y")

      worksheet.write(row_pos, 0, person.first_name)
      worksheet.write(row_pos, 1, person.last_name)
      worksheet.write(row_pos, 2, person.barcode)
      worksheet.write(row_pos, 3, person.location_details)
      worksheet.write(row_pos, 4, person.group_details)
      worksheet.write(row_pos, 5, person.email)
      worksheet.write(row_pos, 6, person.phone)
      worksheet.write(row_pos, 7, person.role)
      worksheet.write(row_pos, 8, created_at)
    end
    # write to file
    workbook.close
    file
  end

  def location_details
    location_name = self.location.name rescue ""
    location_name
  end

  def group_details
    group_name = self.group.name rescue ""
    group_name
  end

end
