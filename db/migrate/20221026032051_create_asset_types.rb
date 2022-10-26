class CreateAssetTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_types, :primary_key => :asset_type_id do |t|
      t.string :name
      t.timestamps
    end
  end
end
