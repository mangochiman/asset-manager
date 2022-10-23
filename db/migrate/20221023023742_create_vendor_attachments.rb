class CreateVendorAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :vendor_attachments, :primary_key => :vendor_attachment_id do |t|
      t.integer :vendor_id
      t.string :name
      t.string :url
      t.string :size
      t.integer :bytes
      t.timestamps
    end
  end
end
