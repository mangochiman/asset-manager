class CreateAssetAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_attachments, :primary_key => :asset_attachment_id do |t|
      t.integer :asset_id
      t.string :name
      t.string :url
      t.string :size
      t.integer :bytes
      t.timestamps
    end
  end
end
