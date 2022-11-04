class AssetReservation < ApplicationRecord
  self.table_name = 'asset_reservations'
  self.primary_key = 'asset_reservation_id'
  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :person_id
  validates_presence_of :asset_id

  validate :no_reservation_overlap, :start_date_cannot_be_in_the_past, :end_date_is_after_start_date

  scope :overlapping, ->(period_start, period_end, asset_id) do
    where "((start_date <= ?) and (end_date >= ?) and (asset_id = ?) )", period_end, period_start, asset_id
  end

  def no_reservation_overlap
    if (AssetReservation.overlapping(start_date, end_date, asset_id).any?)
      errors.add(:base, 'Dates overlap with another reservation')
    end
  end

  def start_date_cannot_be_in_the_past
    errors.add(:start_date, "can't be in the past") if
        !start_date.blank? and start_date < Date.today
  end

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:base, "End date cannot be before the start date")
    end
  end
end
