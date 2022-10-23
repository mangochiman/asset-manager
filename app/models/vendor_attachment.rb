class VendorAttachment < ApplicationRecord
  self.table_name = 'vendor_attachments'
  self.primary_key = 'vendor_attachment_id'

  belongs_to :vendor, foreign_key: :vendor_id
end
