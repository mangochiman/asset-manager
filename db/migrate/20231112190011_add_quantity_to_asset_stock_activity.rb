class AddQuantityToAssetStockActivity < ActiveRecord::Migration[6.0]
  def change
    add_column :asset_stock_activities, :quantity, :integer
  end
end
