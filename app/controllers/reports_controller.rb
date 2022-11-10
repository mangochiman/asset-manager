class ReportsController < ApplicationController
  def asset_list
    @page_header = "Asset List Report"
    @assets = Asset.all
  end

  def asset_details

  end

  def assets_checked_out

  end


end
