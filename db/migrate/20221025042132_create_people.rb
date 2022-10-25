class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people, :primary_key => :person_id do |t|
      t.string :first_name
      t.string :last_name
      t.string :barcode
      t.integer :location_id
      t.integer :group_id
      t.integer :selection_field_id
      t.string :email
      t.text :notes
      t.string :phone
      t.string :role
      t.timestamps
    end
  end
end
