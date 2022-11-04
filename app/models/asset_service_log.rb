class AssetServiceLog < ApplicationRecord
  self.table_name = 'asset_service_logs'
  self.primary_key = 'asset_service_log_id'

  validates_presence_of :asset_id
  validates_presence_of :start_date_expected

  validate :end_date_expected_is_after_start_date_expected, :end_date_actual_is_after_start_date_actual


  def end_date_expected_is_after_start_date_expected
    return if end_date_expected.blank? || start_date_expected.blank?

    if end_date_expected < start_date_expected
      errors.add(:base, "End date cannot be before the start date")
    end
  end

  def end_date_actual_is_after_start_date_actual
    return if end_date_actual.blank? || start_date_actual.blank?

    if end_date_actual < start_date_actual
      errors.add(:base, "End date cannot be before the start date")
    end
  end

end
