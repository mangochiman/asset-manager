class CreatePasswordReminders < ActiveRecord::Migration[6.0]
  def change
    create_table :password_reminders, :primary_key => :password_reminder_id do |t|
      t.integer :user_id
      t.string :password
      t.string :salt
      t.integer :voided, :default => 0
      t.timestamps
    end
  end
end
