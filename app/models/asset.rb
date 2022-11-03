class Asset < ApplicationRecord
  self.table_name = 'assets'
  self.primary_key = 'asset_id'

  has_many :asset_attachments, :foreign_key => :asset_id

  validates_presence_of :name

  def self.retire_reasons
    %w[Damaged Expired Lost Released Sold Stolen Other]
  end
end
