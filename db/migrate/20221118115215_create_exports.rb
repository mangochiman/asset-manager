class CreateExports < ActiveRecord::Migration[6.0]
  def change
    create_table :exports, :primary_key => :export_id do |t|
      t.string :name
      t.date :export_date
      t.integer :bytes
      t.string :url
      t.timestamps
    end
  end
end
