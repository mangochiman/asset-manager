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

    if request.post?
      selection_field = SelectionField.new
      selection_field.field_name = params[:field_name]
      selection_field.field_type = params[:field_type].downcase

      if selection_field.save
        flash[:notice] = 'Record update was successful'
        redirect_to("/selection_fields?field_type=#{params[:field_type]}") and return
      else
        flash[:error] = selection_field.errors.full_messages.join('<br />')
        redirect_to("/selection_fields") and return
      end
    else
      unless params[:field_type].blank?
        required_field_types = %w[status condition job_title shift service_type]
        if !required_field_types.include?(params[:field_type].downcase)
          flash[:error] = "Unknown selection field #{params[:field_type]}"
          redirect_to("/selection_fields")
        end
      end
    end
    @selection_fields = SelectionField.where(['field_type =?', params[:field_type]])
  end

  def update_selection_field
    selection_field = SelectionField.find(params[:selection_field_id])
    selection_field.field_name = params[:field_name]
    if selection_field.save
      flash[:notice] = 'Record update was successful'
      redirect_to("/selection_fields?field_type=#{params[:field_type]}") and return
    else
      flash[:error] = selection_field.errors.full_messages.join('<br />')
      redirect_to("/selection_fields?field_type=#{params[:field_type]}") and return
    end
  end

  def delete_selection_field
    selection_field = SelectionField.find(params[:id])
    field_type = selection_field.field_type
    if selection_field.delete
      flash[:notice] = 'Record deletion was successful'
      redirect_to("/selection_fields?field_type=#{field_type}") and return
    else
      flash[:error] = selection_field.errors.full_messages.join('<br />')
      redirect_to("/selection_fields?field_type=#{field_type}") and return
    end
  end

  def service_items
    @page_header = "Service Items"
    @service_items = ServiceItem.all
    @service_types = SelectionField.where(['field_type =?', 'service_type'])
    if request.post?
      service_item = ServiceItem.new
      service_item.name = params[:name]
      service_item.selection_field_id = params[:selection_field_id]
      if service_item.save
        flash[:notice] = 'Record creation was successful'
        redirect_to("/service_items") and return
      else
        flash[:error] = service_item.errors.full_messages.join('<br />')
        redirect_to("/service_items") and return
      end
    end
  end

  def update_service_item
    service_item = ServiceItem.find(params[:service_item_id])
    service_item.name = params[:name]
    service_item.selection_field_id = params[:selection_field_id]
    if service_item.save
      flash[:notice] = 'Record update was successful'
      redirect_to("/service_items") and return
    else
      flash[:error] = service_item.errors.full_messages.join('<br />')
      redirect_to("/service_items") and return
    end
  end

  def delete_service_item
    service_item = ServiceItem.find(params[:id])
    if service_item.delete
      flash[:notice] = 'Record deletion was successful'
      redirect_to("/service_items") and return
    else
      flash[:error] = service_item.errors.full_messages.join('<br />')
      redirect_to("/service_items") and return
    end
  end

  def report_options
    @page_header = "Report Options"
  end

  def export_all
    @page_header = "Export Data and Files"
  end

end
