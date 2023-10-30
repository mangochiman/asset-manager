class CreateAssetStockAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_stock_attachments, :primary_key => :asset_stock_attachment_id do |t|
      t.integer :asset_stock_id
      t.string :name
      t.string :url
      t.string :size
      t.integer :bytes
      t.timestamps
    end
  end
end
