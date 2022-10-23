class CreateVendors < ActiveRecord::Migration[6.0]
  def change
    create_table :vendors, :primary_key => :vendor_id do |t|
      t.string :name
      t.string :number
      t.string :phone
      t.string :website
      t.string :contact_name
      t.string :email
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.text :notes
      t.timestamps
    end
  end
end
