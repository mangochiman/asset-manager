class SelectionField < ApplicationRecord
  self.table_name = 'selection_fields'
  self.primary_key = 'selection_field_id'

  validates_presence_of :field_name
  validates_presence_of :field_type

end
