class Person < ApplicationRecord
  self.table_name = 'people'
  self.primary_key = 'person_id'

  has_many :person_attachments, :foreign_key => :person_id
  has_one :user

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

end
