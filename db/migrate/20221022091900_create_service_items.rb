class CreateServiceItems < ActiveRecord::Migration[6.0]
  def change
    create_table :service_items, :primary_key => :service_item_id do |t|
      t.string :name
      t.integer :selection_field_id
      t.timestamps
    end
  end
end
