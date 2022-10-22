class ServiceItem < ApplicationRecord
  self.table_name = 'service_items'
  self.primary_key = 'service_item_id'

  validates_presence_of :name
  validates_presence_of :selection_field_id, :message => "Service type can't be blank"
  belongs_to :selection_field, :foreign_key => :selection_field_id

end
