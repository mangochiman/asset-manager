class Project < ApplicationRecord
  self.table_name = 'projects'
  self.primary_key = 'project_id'

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :assets, :foreign_key => :project_id
  has_many :asset_stocks, :foreign_key => :project_id
end
