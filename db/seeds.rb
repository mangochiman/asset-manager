# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
def loadPlans
  company_id = User.random_string(6).upcase
  company_name = "[NAME]"
  billing_email = "billing@gmail.com"
  SystemPlan.create!({subscription_plan: 'Team', assets_quota: 500, storage_quota: 5, admin_quota: 1, user_quota: 100, active: 1, company_id: company_id, company_name: company_name, billing_email: billing_email})
  SystemPlan.create!({subscription_plan: 'Small Business', assets_quota: 2000, storage_quota: 20, admin_quota: 2, user_quota: 100, active: 0, company_id: company_id, company_name: company_name, billing_email: billing_email})
  SystemPlan.create!({subscription_plan: 'Midsize Business', assets_quota: 5000, storage_quota: 50, admin_quota: 3, user_quota: 100, active: 0, company_id: company_id, company_name: company_name, billing_email: billing_email})
  SystemPlan.create!({subscription_plan: 'Enterprise', assets_quota: 10000, storage_quota: 100, admin_quota: 5, user_quota: 100, active: 0, company_id: company_id, company_name: company_name, billing_email: billing_email})
  SystemPlan.create!({subscription_plan: 'Jumbo 1', assets_quota: 15000, storage_quota: 125, admin_quota: 6, user_quota: 100, active: 0, company_id: company_id, company_name: company_name, billing_email: billing_email})
  SystemPlan.create!({subscription_plan: 'Jumbo 2', assets_quota: 20000, storage_quota: 150, admin_quota: 7, user_quota: 100, active: 0, company_id: company_id, company_name: company_name, billing_email: billing_email})
end

def load_service_types
  service_types = %w[Calibration Inspection Maintenance Repair]
  service_types.each do |service_type|
    selection_field = SelectionField.new
    selection_field.field_name = service_type
    selection_field.field_type = "service_type"
    selection_field.save!
  end
end

def load_conditions
  conditions = %w[Fair Good New Poor]
  conditions.each do |condition|
    selection_field = SelectionField.new
    selection_field.field_name = condition
    selection_field.field_type = "condition"
    selection_field.save!
  end
end

def load_locations
  locations = %w[Warehouse]
  locations.each do |location_name|
    location = Location.new
    location.name = location_name
    location.save!
  end
end

def load_asset_types
  asset_types = ["Laptops", "Smart Phones", "Tablets", "Electronics"]
  asset_types.each do |asset_type_name|
    asset_type = AssetType.new
    asset_type.name = asset_type_name
    asset_type.save!
  end
end

def load_groups
  groups = ["Administration", "Human Resources", "Engineering"]
  groups.each do |group_name|
    group = Group.new
    group.name = group_name
    group.save!
  end
end

def load_person_and_user
  person = Person.new
  person.first_name = "System"
  person.last_name = "Administrator"
  person.email = "systemadmin@gmail.com"
  person.role = "System Administrator"
  person.save!

  params = ActiveSupport::HashWithIndifferentAccess.new
  params[:person_id] = person.person_id
  params[:username] = "admin"
  params[:password] = "lowanibwana"
  user = User.new_user(params)
  user.save!
end

loadPlans
load_service_types
load_conditions
load_locations
load_asset_types
load_groups
load_person_and_user