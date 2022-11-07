class CreateSystemActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :system_activities, :primary_key => :system_activities_id do |t|
      t.integer :person_id
      t.string :action
      t.string :description
      t.timestamps
    end
  end
end
