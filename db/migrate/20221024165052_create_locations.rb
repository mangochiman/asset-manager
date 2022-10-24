class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations, :primary_key => :location_id do |t|
      t.string :name
      t.timestamps
    end
  end
end
