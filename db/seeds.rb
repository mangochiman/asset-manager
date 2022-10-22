# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
def loadPlans
  SystemPlan.create({subscription_plan: 'Team', assets_quota: 500, storage_quota: 5, admin_quota: 1, user_quota: 100, active: 1, company_id: '000001', company_name: 'WebTech++', billing_email: ''})
  SystemPlan.create({subscription_plan: 'Small Business', assets_quota: 2000, storage_quota: 20, admin_quota: 2, user_quota: 100, active: 0, company_id: '000001', company_name: 'WebTech++', billing_email: ''})
  SystemPlan.create({subscription_plan: 'Midsize Business', assets_quota: 5000, storage_quota: 50, admin_quota: 3, user_quota: 100, active: 0, company_id: '000001', company_name: 'WebTech++', billing_email: ''})
  SystemPlan.create({subscription_plan: 'Enterprise', assets_quota: 10000, storage_quota: 100, admin_quota: 5, user_quota: 100, active: 0, company_id: '000001', company_name: 'WebTech++', billing_email: ''})
  SystemPlan.create({subscription_plan: 'Jumbo 1', assets_quota: 15000, storage_quota: 125, admin_quota: 6, user_quota: 100, active: 0, company_id: '000001', company_name: 'WebTech++', billing_email: ''})
  SystemPlan.create({subscription_plan: 'Jumbo 2', assets_quota: 20000, storage_quota: 150, admin_quota: 7, user_quota: 100, active: 0, company_id: '000001', company_name: 'WebTech++', billing_email: ''})
end
loadPlans
