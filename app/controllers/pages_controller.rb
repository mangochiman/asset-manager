class PagesController < ApplicationController
  def home
    @page_header = "Dashboard"
  end

  def new_asset_menu
    @page_header = "Assets"
  end

  def system_overview
    @page_header = "System Overview"
  end

  def selection_fields
    @page_header = "Selection Fields"
  end

  def service_items
    @page_header = "Service Items"
  end

  def report_options

  end

end
