class AddRefIdToAssetStockActivity < ActiveRecord::Migration[6.0]
  def change
    add_column :asset_stock_activities, :ref_id, :integer
  end
end
