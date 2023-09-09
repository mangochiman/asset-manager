class Project < ApplicationRecord
  self.table_name = 'projects'
  self.primary_key = 'project_id'

  validates_presence_of :name
  validates_uniqueness_of :name

end
