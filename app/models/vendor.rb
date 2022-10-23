class Vendor < ApplicationRecord
  self.table_name = 'vendors'
  self.primary_key = 'vendor_id'

  has_many :vendor_attachments, foreign_key: :vendor_id

end
