class SystemPlan < ApplicationRecord
  self.table_name = 'system_plans'
  self.primary_key = 'system_plan_id'

  validates_presence_of :billing_email
  validates_uniqueness_of :subscription_plan
end
