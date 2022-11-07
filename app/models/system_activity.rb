class SystemActivity < ApplicationRecord
  self.table_name = 'system_activities'
  self.primary_key = 'system_activities_id'

  belongs_to :person, foreign_key: :person_id

  def self.log(person_id_param, action_params, description_param)
    system_activity = SystemActivity.new
    system_activity.person_id = person_id_param
    system_activity.action = action_params
    system_activity.description = description_param
    system_activity.save
  end

  def person_details
    person = self.person
    person_info = (person.first_name.to_s + " " + person.last_name.to_s) rescue ""
    person_info
  end

end
