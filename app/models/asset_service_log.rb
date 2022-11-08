class AssetServiceLog < ApplicationRecord
  self.table_name = 'asset_service_logs'
  self.primary_key = 'asset_service_log_id'

  validates_presence_of :asset_id
  validates_presence_of :start_date_expected

  validate :end_date_expected_is_after_start_date_expected, :end_date_actual_is_after_start_date_actual

  belongs_to :selection_field, :foreign_key => :service_item_id

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

  def service_type_details
    service_name = self.selection_field.field_name rescue ""
    service_name
  end

  def serviced_by_details
    performed_by = self.performed_by
    details = performed_by.to_s + " : "
    details = "" if self.performed_by.blank?

    if !self.vendor_id.blank?
      vendor = Vendor.find(self.vendor_id) rescue ""
      details = (details + " " +  vendor.name) if !vendor.blank?
    end
    if !self.person_id.blank?
      person = Person.find(self.person_id) rescue ""
      details = (details + " " + person.first_name.to_s + " " +  person.last_name.to_s) if !person.blank?
    end
    details
  end

end
