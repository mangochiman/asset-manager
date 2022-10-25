class Person < ApplicationRecord
  self.table_name = 'people'
  self.primary_key = 'person_id'

  has_many :person_attachments, :foreign_key => :person_id
  has_one :user

end
