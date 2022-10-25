class CreatePersonAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :person_attachments, :primary_key => :person_attachment_id do |t|
      t.integer :person_id
      t.string :name
      t.string :url
      t.string :size
      t.integer :bytes
      t.timestamps
    end
  end
end
