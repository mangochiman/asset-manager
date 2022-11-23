class CreateSystemPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :system_plans, :primary_key => :system_plan_id do |t|
      t.string :company_id
      t.string :subscription_plan
      t.integer :assets_quota
      t.integer :storage_quota
      t.integer :admin_quota
      t.integer :user_quota
      t.string :company_name
      t.string :billing_email
      t.integer :active
      t.decimal :cost_per_month
      t.decimal :addition_admin_cost
      t.string :currency_symbol
      t.string :currency_description

      t.timestamps
    end
  end
end
