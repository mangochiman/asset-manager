class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, :primary_key => :user_id do |t|
      t.integer :person_id
      t.string :username
      t.string :password
      t.string :salt
      t.string :secret_question
      t.string :secret_answer
      t.integer :voided, :default => 0
      t.integer :voided_by
      t.date :date_voided
      t.timestamps
    end
  end
end
