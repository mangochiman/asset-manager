class CreateSelectionFields < ActiveRecord::Migration[6.0]
  def change
    create_table :selection_fields, :primary_key => :selection_field_id do |t|
      t.string :field_name
      t.string :field_type
      t.timestamps
    end
  end
end
