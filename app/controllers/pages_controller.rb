class PagesController < ApplicationController
  def home
    @page_header = "Dashboard"
  end

  def new_asset_menu
    @page_header = "Assets"
  end

  def system_overview
    @page_header = "System Overview"
    @active_system_plan = SystemPlan.where('active =?', 1).last
    if request.post?
      @active_system_plan.billing_email = params[:email]
      if @active_system_plan.save
        flash[:notice] = 'Record update was successful'
        redirect_to('/system_overview') and return
      else
        flash[:error] = @active_system_plan.errors.full_messages.join('<br />')
        redirect_to("/system_overview") and return
      end
    end
  end

  def selection_fields
    @page_header = "Selection Fields"
  end

  def service_items
    @page_header = "Service Items"
  end

  def report_options
    @page_header = "Report Options"
  end

  def export_all
    @page_header = "Export Data and Files"
  end

end
