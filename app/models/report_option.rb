class ReportOption < ApplicationRecord
  self.table_name = 'report_options'
  self.primary_key = 'report_option_id'

  validates_presence_of :header
  validates_presence_of :footer

end
