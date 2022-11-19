class Export < ApplicationRecord
  self.table_name = 'exports'
  self.primary_key = 'export_id'

  def self.log(data)
    export = Export.new
    export.name = data[:export_name]
    export.export_date = Date.today
    export.bytes = data[:file_size]
    export.url = data[:file_path]
    export.save
  end
end
