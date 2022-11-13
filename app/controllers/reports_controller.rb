class ReportsController < ApplicationController
  def asset_list
    @page_header = "Asset List Report"
    @assets = Asset.all
  end

  def asset_details
    @page_header = "Asset Details"
    @assets = Asset.all
  end

  def assets_checked_out
    @page_header = "Assets Checked Out"
    @assets = []
    Asset.all.each do |asset|
      @assets << asset if asset.state.to_s.match(/out/i)
    end
  end

  def personnel_list
    @page_header = "Personnel List Report"
    @people = Person.all
  end

  def vendor_list
    @page_header = "Vendor List Report"
    @vendors = Vendor.all
  end

end
