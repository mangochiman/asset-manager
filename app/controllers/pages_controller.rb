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
    report_option = ReportOption.last
    @header = report_option.header rescue nil
    @footer = report_option.footer rescue nil
    @logo_url = report_option.logo_url rescue nil

    if request.post?
      report_option = ReportOption.last
      report_option = ReportOption.new if report_option.blank?
      report_option.header = params[:header]
      report_option.footer = params[:footer]
      if report_option.save
        unless params[:logo].blank?
          logo = params[:logo]
          extension = File.extname(logo).downcase
          file_extensions = %w[.png .jpeg .jpg]
          if !file_extensions.include?(extension)
            flash[:error] = "Unsupported file. You can only upload .png, .jpeg, .jpg file extensions"
            redirect_to("/report_options") and return
          end
          file_name = "logo#{extension}"
          File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |file|
            file.write(params[:logo].read)
          end
          report_option.logo_url = '/uploads/' + file_name
          report_option.save!
        end
        flash[:notice] = 'Record update was successful'
        redirect_to("/report_options") and return
      else
        flash[:error] = report_option.errors.full_messages.join('<br />')
        redirect_to("/report_options") and return
      end
    end
  end

  def export_all
    @page_header = "Export Data and Files"
  end

  def new_vendor
    @page_header = "New Vendor"
    if request.post?
      vendor = Vendor.new
      vendor.name = params[:name]
      vendor.number = params[:number]
      vendor.phone = params[:phone]
      vendor.website = params[:website]
      vendor.contact_name = params[:contact_name]
      vendor.email = params[:email]
      vendor.address1 = params[:address1]
      vendor.address2 = params[:address2]
      vendor.city = params[:city]
      vendor.state = params[:state]
      vendor.postal_code = params[:postal_code]
      vendor.country = params[:country]
      vendor.notes = params[:notes]
      if vendor.save
        unless params[:file].blank?
          errors = []
          params[:file].each do |file_upload|
            extension = File.extname(file_upload).downcase
            original_filename = file_upload.original_filename.split(".")[0].parameterize
            file_name = "#{original_filename}#{extension}"
            file_size_readable = ActionController::Base.helpers.number_to_human_size(file_upload.size)
            file_size_bytes = file_upload.size

            vendor_attachment = VendorAttachment.new
            vendor_attachment.vendor_id = vendor.vendor_id
            vendor_attachment.name = original_filename
            vendor_attachment.size = file_size_readable
            vendor_attachment.bytes = file_size_bytes
            vendor_attachment.url = '/uploads/' + file_name
            if vendor_attachment.save
              File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |file|
                file.write(file_upload.read)
              end
            else
              errors << "#{original_filename} couldn't be uploaded. Check the file size"
            end
          end
          unless errors.blank?
            flash[:error] = errors.join('<br />')
            redirect_to("/new_vendor") and return
          end
        end

        flash[:notice] = 'Record creation was successful'
        redirect_to("/new_vendor") and return
      else
        flash[:error] = vendor.errors.full_messages.join('<br />')
        redirect_to("/new_vendor") and return
      end
    end
  end

  def list_vendors
    @page_header = "Vendors List"
    @vendors = Vendor.order('vendor_id DESC')
  end

  def edit_vendor
    @vendor = Vendor.find(params[:vendor_id])
    @page_header = "Updating vendor: #{@vendor.name}"

    if request.post?
      @vendor.name = params[:name]
      @vendor.number = params[:number]
      @vendor.phone = params[:phone]
      @vendor.website = params[:website]
      @vendor.contact_name = params[:contact_name]
      @vendor.email = params[:email]
      @vendor.address1 = params[:address1]
      @vendor.address2 = params[:address2]
      @vendor.city = params[:city]
      @vendor.state = params[:state]
      @vendor.postal_code = params[:postal_code]
      @vendor.country = params[:country]
      @vendor.notes = params[:notes]
      if @vendor.save
        unless params[:file].blank?
          errors = []
          params[:file].each do |file_upload|
            extension = File.extname(file_upload).downcase
            original_filename = file_upload.original_filename.split(".")[0].parameterize
            file_name = "#{original_filename}#{extension}"
            file_size_readable = ActionController::Base.helpers.number_to_human_size(file_upload.size)
            file_size_bytes = file_upload.size

            vendor_attachment = VendorAttachment.new
            vendor_attachment.vendor_id = @vendor.vendor_id
            vendor_attachment.name = original_filename
            vendor_attachment.url = '/uploads/' + file_name
            vendor_attachment.size = file_size_readable
            vendor_attachment.bytes = file_size_bytes
            if vendor_attachment.save
              File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |file|
                file.write(file_upload.read)
              end
            else
              errors << "#{original_filename} couldn't be uploaded. Check the file size"
            end
          end
          unless errors.blank?
            flash[:error] = errors.join('<br />')
            redirect_to("/edit_vendor?vendor_id=#{params[:vendor_id]}") and return
          end
        end

        flash[:notice] = 'Record update was successful'
        redirect_to("/list_vendors") and return
      else
        flash[:error] = @vendor.errors.full_messages.join('<br />')
        redirect_to("/edit_vendor?vendor_id=#{params[:vendor_id]}") and return
      end
    end

  end

  def delete_vendor_attachment
    vendor_attachment = VendorAttachment.find(params[:id])
    file_path = Rails.root.to_s + '/public' + vendor_attachment.url.to_s
    if vendor_attachment.delete
      File.delete(file_path) if File.exist?(file_path)
      flash[:notice] = 'Record deletion was successful'
      redirect_to("/edit_vendor?vendor_id=#{params[:vendor_id]}") and return
    else
      flash[:error] = vendor_attachment.errors.full_messages.join('<br />')
      redirect_to("/edit_vendor?vendor_id=#{params[:vendor_id]}") and return
    end
  end

  def delete_vendor
    vendor = Vendor.find(params[:id])
    vendor_attachments = vendor.vendor_attachments
    ActiveRecord::Base.transaction do
      vendor_attachments.each do |vendor_attachment|
        file_path = Rails.root.to_s + '/public' + vendor_attachment.url.to_s
        vendor_attachment.delete
        File.delete(file_path) if File.exist?(file_path)
      end
      vendor.delete
    end
    flash[:notice] = 'Record deletion was successful'
    redirect_to("/list_vendors") and return
  end

  def groups
    @page_header = "Groups"
    if request.post?
      group = Group.new
      group.name = params[:name]
      if group.save
        flash[:notice] = 'Record creation was successful'
        redirect_to("/groups") and return
      else
        flash[:error] = group.errors.full_messages.join('<br />')
        redirect_to("/groups") and return
      end
    end
    @groups = Group.order("group_id DESC")
  end

  def update_group
    group = Group.find(params[:group_id])
    group.name = params[:name]
    if group.save
      flash[:notice] = 'Record update was successful'
      redirect_to("/groups") and return
    else
      flash[:error] = group.errors.full_messages.join('<br />')
      redirect_to("/groups") and return
    end
  end

  def delete_group
    group = Group.find(params[:id])
    if group.delete
      flash[:notice] = 'Record deletion was successful'
      redirect_to("/groups") and return
    else
      flash[:error] = group.errors.full_messages.join('<br />')
      redirect_to("/groups") and return
    end
  end

  def locations
    @page_header = "Locations"
    if request.post?
      location = Location.new
      location.name = params[:name]
      if location.save
        flash[:notice] = 'Record creation was successful'
        redirect_to("/locations") and return
      else
        flash[:error] = location.errors.full_messages.join('<br />')
        redirect_to("/locations") and return
      end
    end
    @locations = Location.order("location_id DESC")
  end

  def delete_location
    location = Location.find(params[:id])
    if location.delete
      flash[:notice] = 'Record deletion was successful'
      redirect_to("/locations") and return
    else
      flash[:error] = location.errors.full_messages.join('<br />')
      redirect_to("/locations") and return
    end
  end

  def update_location
    location = Location.find(params[:location_id])
    location.name = params[:name]
    if location.save
      flash[:notice] = 'Record update was successful'
      redirect_to("/locations") and return
    else
      flash[:error] = location.errors.full_messages.join('<br />')
      redirect_to("/locations") and return
    end
  end

  def new_person
    
  end
end
