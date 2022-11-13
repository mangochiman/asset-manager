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

  def completed_service
    @page_header = "Completed Service Report"
    @completed_services = AssetServiceLog.completed_service
  end

  def overdue_service
    @page_header = "Overdue Service Report"
    @overdue_service = AssetServiceLog.overdue_service
  end

  def service_schedule
    @page_header = "Service Schedule Report"
    @scheduled_services = AssetServiceLog.service_schedule
  end

end
