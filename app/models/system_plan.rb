class SystemPlan < ApplicationRecord
  self.table_name = 'system_plans'
  self.primary_key = 'system_plan_id'

  validates_presence_of :billing_email
  validates_uniqueness_of :subscription_plan

  def self.trial_version_days
    90
  end

  def self.active_plan
    active_plan = SystemPlan.where(["active =?", 1]).last
    active_plan
  end

  def self.is_trial?
    trial_version = active_plan.subscription_plan.to_s.squish.downcase == "trial"
    trial_version
  end

  def self.trial_end_date
    start_date = active_plan.created_at.to_date
    expected_end_date = start_date + self.trial_version_days.days
    expected_end_date
  end

  def self.trial_days_remaining
    start_date = self.active_plan.created_at.to_date
    days_gone = (Date.today - start_date).to_i
    days_remaining = self.trial_version_days - days_gone
    days_remaining = 0 if days_remaining < 0
    days_remaining
  end

  def self.trial_ended?
    trial_ended = false
    if self.is_trial?
      trial_ended = true if self.trial_days_remaining <= 0
    end
    trial_ended
  end

end
