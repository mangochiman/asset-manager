class PagesController < ApplicationController
  def home
    @page_header = "Dashboard"
    @asset_count = Asset.count
    @people_count = Person.count
    @vendors_count = Vendor.count
    dirname = Rails.root.to_s + "/public/uploads/*"
    file_storage_number = Dir[dirname].select { |f|
      File.file?(f) }.sum { |f| File.size(f)
    }
    @file_storage_size = ActionController::Base.helpers.number_to_human_size(file_storage_number)
    @recently_added_assets = Asset.order("created_at DESC").limit(10)
    @recently_system_activities = SystemActivity.order("created_at DESC").limit(10)
  end


  def new_asset_menu
    @page_header = "New Asset"
    @asset = Asset.new
    if params[:ref_id]
      @page_header = "Clone Asset"
      @asset = Asset.find(params[:ref_id]) rescue Asset.new
    end
    if request.post?
      asset = Asset.new
      asset.name = params[:name]
      asset.barcode = params[:barcode]
      asset.asset_type_id = params[:asset_type_id]
      asset.status_id = params[:status_selection_field_id]
      asset.location_id = params[:location_id]
      asset.condition_id = params[:condition_selection_field_id]
      asset.vendor_id = params[:vendor_id]
      asset.serial_number = params[:serial_number]
      asset.manufacturer = params[:manufacturer]
      asset.brand = params[:brand]
      asset.model = params[:model]
      asset.unit_price = params[:price]
      asset.date_purchased = params[:date_purchased]
      asset.order_number = params[:order_number]
      asset.account_code = params[:account_code]
      asset.warranty_end = params[:warranty_end]
      asset.notes = params[:notes]

      if asset.save
        person_id_param = "1" #TODO
        action_params = "Add"
        description_param = "Created new asset record: #{asset.name}"
        SystemActivity.log(person_id_param, action_params, description_param)
        errors = []
        unless params[:file].blank?
          params[:file].each do |file_upload|
            extension = File.extname(file_upload).downcase
            original_filename = file_upload.original_filename.split(".")[0].parameterize
            file_name = "#{original_filename}#{extension}"
            file_size_readable = ActionController::Base.helpers.number_to_human_size(file_upload.size)
            file_size_bytes = file_upload.size

            asset_attachment = AssetAttachment.new
            asset_attachment.asset_id = asset.asset_id
            asset_attachment.name = original_filename
            asset_attachment.size = file_size_readable
            asset_attachment.bytes = file_size_bytes
            asset_attachment.url = '/uploads/' + file_name
            if asset_attachment.save
              File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |file|
                file.write(file_upload.read)
              end
            else
              errors << "#{original_filename} couldn't be uploaded. Check the file size"
            end
          end
        end

        unless params[:picture].blank?
          file_upload = params[:picture]
          extension = File.extname(file_upload).downcase
          original_filename = file_upload.original_filename.split(".")[0].parameterize
          file_name = "#{original_filename}#{extension}"

          file_extensions = %w[.png .jpeg .jpg]
          if !file_extensions.include?(extension)
            errors << "Unsupported file for asset picture. You can only upload .png, .jpeg, .jpg file extensions"
          else
            File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |file|
              file.write(params[:picture].read)
            end
            asset.photo_url = '/uploads/' + file_name
            asset.save!
          end
        end

        if params[:display_image].to_s == "on"
          asset.photo_url = @asset.photo_url
          asset.save!
        end

        unless params[:asset_attachment_ids].blank?
          params[:asset_attachment_ids].each do |asset_attachment_id|
            asset_attachment_new = AssetAttachment.new
            asset_attachment_old = AssetAttachment.find(asset_attachment_id)
            asset_attachment_new.asset_id = asset.asset_id
            asset_attachment_new.name = asset_attachment_old.name
            asset_attachment_new.url = asset_attachment_old.url
            asset_attachment_new.size = asset_attachment_old.size
            asset_attachment_new.bytes = asset_attachment_old.bytes
            if asset_attachment_new.save
            else
              errors << "Unable to copy image #{asset_attachment_old.url}"
            end
          end
        end

        unless errors.blank?
          flash[:error] = errors.join('<br />')
          redirect_to("/new_asset_menu") and return
        end

        flash[:notice] = 'Record creation was successful'
        redirect_to("/new_asset_menu") and return
      else
        flash[:error] = asset.errors.full_messages.join('<br />')
        redirect_to("/new_asset_menu") and return
      end
    end

    @asset_types = AssetType.all
    @status_selection_fields = SelectionField.where(['field_type =?', 'status'])
    @condition_selection_fields = SelectionField.where(['field_type =?', 'condition'])
    @people = Person.all
    @vendors = Vendor.all
    @locations = Location.all
  end

  def list_assets
    @page_header = "List assets"
    @assets = Asset.order('asset_id DESC')
  end

  def edit_asset
    @asset = Asset.find(params[:asset_id])

    if request.post?
      asset = @asset
      asset.name = params[:name]
      asset.barcode = params[:barcode]
      asset.asset_type_id = params[:asset_type_id]
      #asset.status_id = params[:status_selection_field_id]
      asset.location_id = params[:location_id]
      asset.condition_id = params[:condition_selection_field_id]
      asset.vendor_id = params[:vendor_id]
      asset.serial_number = params[:serial_number]
      asset.manufacturer = params[:manufacturer]
      asset.brand = params[:brand]
      asset.model = params[:model]
      asset.unit_price = params[:price]
      asset.date_purchased = params[:date_purchased]
      asset.order_number = params[:order_number]
      asset.account_code = params[:account_code]
      asset.warranty_end = params[:warranty_end]
      asset.notes = params[:notes]

      if asset.save
        person_id_param = "1" #TODO
        action_params = "Update"
        description_param = "Created new asset record: #{asset.name}"
        SystemActivity.log(person_id_param, action_params, description_param)
        errors = []
        unless params[:file].blank?
          params[:file].each do |file_upload|
            extension = File.extname(file_upload).downcase
            original_filename = file_upload.original_filename.split(".")[0].parameterize
            file_name = "#{original_filename}#{extension}"
            file_size_readable = ActionController::Base.helpers.number_to_human_size(file_upload.size)
            file_size_bytes = file_upload.size

            asset_attachment = AssetAttachment.new
            asset_attachment.asset_id = asset.asset_id
            asset_attachment.name = original_filename
            asset_attachment.size = file_size_readable
            asset_attachment.bytes = file_size_bytes
            asset_attachment.url = '/uploads/' + file_name
            if asset_attachment.save
              File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |file|
                file.write(file_upload.read)
              end
            else
              errors << "#{original_filename} couldn't be uploaded. Check the file size"
            end
          end
        end

        unless params[:picture].blank?
          file_upload = params[:picture]
          extension = File.extname(file_upload).downcase
          original_filename = file_upload.original_filename.split(".")[0].parameterize
          file_name = "#{original_filename}#{extension}"

          file_extensions = %w[.png .jpeg .jpg]
          if !file_extensions.include?(extension)
            errors << "Unsupported file for asset picture. You can only upload .png, .jpeg, .jpg file extensions"
          else
            file_path = Rails.root.to_s + '/public' + asset.photo_url.to_s
            File.delete(file_path) if File.exist?(file_path)
            File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |file|
              file.write(params[:picture].read)
            end
            asset.photo_url = '/uploads/' + file_name
            asset.save!
          end
        end

        unless errors.blank?
          flash[:error] = errors.join('<br />')
          redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
        end

        flash[:notice] = 'Record update was successful'
        redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
      else
        flash[:error] = asset.errors.full_messages.join('<br />')
        redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
      end
    end

    @page_header = @asset.name
    @service_started = @asset.service_started? #checked_out?
    @checked_out = @asset.checked_out?
    @retired = @asset.retired?
    @state = @asset.state
    @checked_out_date = @asset.checked_out_date
    @asset_types = AssetType.all
    @status_selection_fields = SelectionField.where(['field_type =?', 'status'])
    @condition_selection_fields = SelectionField.where(['field_type =?', 'condition'])
    @people = Person.all
    @vendors = Vendor.all
    @locations = Location.all
    @retire_reasons = Asset.retire_reasons
    @service_types = SelectionField.where(['field_type =?', 'service_type'])
    @vendors = Vendor.all
    @people = Person.all
    @asset_service_logs = @asset.asset_service_logs
    @asset_reservations = @asset.asset_reservations
    @asset_check_in_out_activities = @asset.check_in_out_activities
  end

  def delete_asset
    asset = Asset.find(params[:id])
    asset_attachments = asset.asset_attachments
    errors = []
    ActiveRecord::Base.transaction do
      if asset.delete
        person_id_param = "1" #TODO
        action_params = "Delete"
        description_param = "Deleted asset record: #{asset.name}"
        SystemActivity.log(person_id_param, action_params, description_param)

        asset_attachments.each do |asset_attachment|
          file_path = Rails.root.to_s + '/public' + asset_attachment.url.to_s
          if asset_attachment.delete
            File.delete(file_path) if File.exist?(file_path)
          end
        end
      else
        errors << asset.errors.full_messages.join('<br />')
      end
    end
    if errors.blank?
      flash[:notice] = 'Record deletion was successful'
      redirect_to("/list_assets") and return
    else
      flash[:error] = errors
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

  def retire_asset
    asset = Asset.find(params[:asset_id])
    asset.retired = 1
    asset.retire_reason = params[:retire_reason]
    asset.date_retired = params[:retire_date]
    asset.retired_by = '#' #TODO
    asset.retire_comments = params[:comments]
    if asset.save
      person_id_param = "1" #TODO
      action_params = "Retired"
      description_param = "Retired asset record: #{asset.name}"
      SystemActivity.log(person_id_param, action_params, description_param)
      flash[:notice] = 'Asset retirement was successful'
      redirect_to("/list_assets") and return
    else
      flash[:error] = asset.errors.full_messages.join('<br />')
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

  def delete_asset_attachment
    asset_attachment = AssetAttachment.find(params[:id])
    file_path = Rails.root.to_s + '/public' + asset_attachment.url.to_s
    if asset_attachment.delete
      File.delete(file_path) if File.exist?(file_path)
      flash[:notice] = 'Record deletion was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_attachment.errors.full_messages.join('<br />')
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

  def system_overview
    @page_header = "System Overview"
    @active_system_plan = SystemPlan.where('active =?', 1).last
    if request.post?
      @active_system_plan.billing_email = params[:email]
      if @active_system_plan.save
        person_id_param = "1" #TODO
        action_params = "Update"
        description_param = "Updated billing address: #{params[:email]}"
        SystemActivity.log(person_id_param, action_params, description_param)
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
        person_id_param = "1" #TODO
        action_params = "Add"
        description_param = "Created new selection field: #{selection_field.field_type}"
        SystemActivity.log(person_id_param, action_params, description_param)

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
      person_id_param = "1" #TODO
      action_params = "Update"
      description_param = "Updated selection field: #{selection_field.field_name}"
      SystemActivity.log(person_id_param, action_params, description_param)

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
        person_id_param = "1" #TODO
        action_params = "Add"
        description_param = "Created new service item record"
        SystemActivity.log(person_id_param, action_params, description_param)

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
      person_id_param = "1" #TODO
      action_params = "Update"
      description_param = "Updated service item record"
      SystemActivity.log(person_id_param, action_params, description_param)

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
        person_id_param = "1" #TODO
        action_params = "Add"
        description_param = "Created new vendor record: #{vendor.name}"
        SystemActivity.log(person_id_param, action_params, description_param)

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
        person_id_param = "1" #TODO
        action_params = "Update"
        description_param = "Updated vendor record: #{@vendor.name}"
        SystemActivity.log(person_id_param, action_params, description_param)

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
      person_id_param = "1" #TODO
      action_params = "Delete"
      description_param = "Deleted vendor record: #{vendor.name}"
      SystemActivity.log(person_id_param, action_params, description_param)
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
        person_id_param = "1" #TODO
        action_params = "Add"
        description_param = "Created new group record: #{group.name}"
        SystemActivity.log(person_id_param, action_params, description_param)

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
      person_id_param = "1" #TODO
      action_params = "Update"
      description_param = "Updated group record: #{group.name}"
      SystemActivity.log(person_id_param, action_params, description_param)

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
      person_id_param = "1" #TODO
      action_params = "Delete"
      description_param = "Deleted group record: #{group.name}"
      SystemActivity.log(person_id_param, action_params, description_param)

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
        person_id_param = "1" #TODO
        action_params = "Add"
        description_param = "Created new location record: #{location.name}"
        SystemActivity.log(person_id_param, action_params, description_param)

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
      person_id_param = "1" #TODO
      action_params = "Delete"
      description_param = "Deleted location record: #{location.name}"
      SystemActivity.log(person_id_param, action_params, description_param)

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
      person_id_param = "1" #TODO
      action_params = "Update"
      description_param = "Updated location record: #{location.name}"
      SystemActivity.log(person_id_param, action_params, description_param)

      flash[:notice] = 'Record update was successful'
      redirect_to("/locations") and return
    else
      flash[:error] = location.errors.full_messages.join('<br />')
      redirect_to("/locations") and return
    end
  end

  def new_person
    @page_header = "New person"
    @locations = Location.all
    if request.post?
      person = Person.new
      person.first_name = params[:first_name]
      person.last_name = params[:last_name]
      person.barcode = params[:barcode]
      person.location_id = params[:location_id]
      person.group_id = params[:group_id]
      person.selection_field_id = params[:selection_field_id]
      person.email = params[:email]
      person.notes = params[:notes]
      person.phone = params[:phone]
      person.role = params[:role]

      if person.save
        person_id_param = "1" #TODO
        action_params = "Add"
        description_param = "Created new person record: #{person.first_name.to_s + ' ' + person.last_name.to_s}"
        SystemActivity.log(person_id_param, action_params, description_param)

        unless params[:file].blank?
          errors = []
          params[:file].each do |file_upload|
            extension = File.extname(file_upload).downcase
            original_filename = file_upload.original_filename.split(".")[0].parameterize
            file_name = "#{original_filename}#{extension}"
            file_size_readable = ActionController::Base.helpers.number_to_human_size(file_upload.size)
            file_size_bytes = file_upload.size

            person_attachment = PersonAttachment.new
            person_attachment.person_id = person.person_id
            person_attachment.name = original_filename
            person_attachment.size = file_size_readable
            person_attachment.bytes = file_size_bytes
            person_attachment.url = '/uploads/' + file_name
            if person_attachment.save
              File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |file|
                file.write(file_upload.read)
              end
            else
              errors << "#{original_filename} couldn't be uploaded. Check the file size"
            end
          end
          unless errors.blank?
            flash[:error] = errors.join('<br />')
            redirect_to("/new_person") and return
          end
        end

        unless params[:username].blank?
          params[:person_id] = person.person_id
          params[:username] = params[:username]
          params[:password] = params[:password]
          user = User.new_user(params)
          if user.save
          else
            flash[:error] = user.errors.full_messages.join('<br />')
            redirect_to("/new_person") and return
          end
        end

        flash[:notice] = 'Record creation was successful'
        redirect_to("/new_person") and return
      else
        flash[:error] = person.errors.full_messages.join('<br />')
        redirect_to("/new_person") and return
      end
    end
    @selection_fields = SelectionField.where(['field_type =?', 'job_title'])
    @groups = Group.all
    @system_roles = User.roles
  end

  def list_people
    @page_header = "List people"
    @people = Person.order("person_id DESC")
  end

  def edit_person
    @page_header = "Edit Person"
    @person = Person.find(params[:person_id])
    if request.post?
      person = @person
      person.first_name = params[:first_name]
      person.last_name = params[:last_name]
      person.barcode = params[:barcode]
      person.location_id = params[:location_id]
      person.group_id = params[:group_id]
      person.selection_field_id = params[:selection_field_id]
      person.email = params[:email]
      person.notes = params[:notes]
      person.phone = params[:phone]
      if person.user.blank?
        person.role = params[:role] unless params[:role].blank?
      end

      if person.save
        person_id_param = "1" #TODO
        action_params = "Add"
        description_param = "Updated person record: #{person.first_name.to_s + ' ' + person.last_name.to_s}"
        SystemActivity.log(person_id_param, action_params, description_param)

        unless params[:file].blank?
          errors = []
          params[:file].each do |file_upload|
            extension = File.extname(file_upload).downcase
            original_filename = file_upload.original_filename.split(".")[0].parameterize
            file_name = "#{original_filename}#{extension}"
            file_size_readable = ActionController::Base.helpers.number_to_human_size(file_upload.size)
            file_size_bytes = file_upload.size

            person_attachment = PersonAttachment.new
            person_attachment.person_id = person.person_id
            person_attachment.name = original_filename
            person_attachment.size = file_size_readable
            person_attachment.bytes = file_size_bytes
            person_attachment.url = '/uploads/' + file_name
            if person_attachment.save
              File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |file|
                file.write(file_upload.read)
              end
            else
              errors << "#{original_filename} couldn't be uploaded. Check the file size"
            end
          end
          unless errors.blank?
            flash[:error] = errors.join('<br />')
            redirect_to("/edit_person?person_id=#{params[:person_id]}") and return
          end
        end

        if person.user.blank?
          unless params[:username].blank?
            params[:person_id] = person.person_id
            params[:username] = params[:username]
            params[:password] = params[:password]
            user = User.new_user(params)
            if user.save
            else
              flash[:error] = user.errors.full_messages.join('<br />')
              redirect_to("/edit_person?person_id=#{params[:person_id]}") and return
            end
          end
        end

        flash[:notice] = 'Record creation was successful'
        redirect_to("/list_people") and return
      else
        flash[:error] = person.errors.full_messages.join('<br />')
        redirect_to("/edit_person?person_id=#{params[:person_id]}") and return
      end
    end

    @locations = Location.all
    @selection_fields = SelectionField.where(['field_type =?', 'job_title'])
    @groups = Group.all
    @system_roles = User.roles
  end

  def delete_person
    person = Person.find(params[:id])
    person_attachments = person.person_attachments
    ActiveRecord::Base.transaction do
      person_attachments.each do |person_attachment|
        file_path = Rails.root.to_s + '/public' + person_attachment.url.to_s
        person_attachment.delete
        File.delete(file_path) if File.exist?(file_path)
      end
      person.user.delete unless person.user.blank?
      person.delete
      person_id_param = "1" #TODO
      action_params = "Delete"
      description_param = "Deleted person record: #{person.first_name} #{person.last_name}"
      SystemActivity.log(person_id_param, action_params, description_param)
    end
    flash[:notice] = 'Record deletion was successful'
    redirect_to("/list_people") and return
  end

  def delete_person_attachment
    person_attachment = PersonAttachment.find(params[:id])
    file_path = Rails.root.to_s + '/public' + person_attachment.url.to_s
    if person_attachment.delete
      File.delete(file_path) if File.exist?(file_path)
      flash[:notice] = 'Record deletion was successful'
      redirect_to("/edit_person?person_id=#{params[:person_id]}") and return
    else
      flash[:error] = person_attachment.errors.full_messages.join('<br />')
      redirect_to("/edit_person?person_id=#{params[:person_id]}") and return
    end
  end

  def asset_types
    @page_header = "Asset Types"
    if request.post?
      asset_type = AssetType.new
      asset_type.name = params[:name]
      if asset_type.save
        person_id_param = "1" #TODO
        action_params = "Add"
        description_param = "Created new asset type: #{asset_type.name}"
        SystemActivity.log(person_id_param, action_params, description_param)

        flash[:notice] = 'Record creation was successful'
        redirect_to("/asset_types") and return
      else
        flash[:error] = asset_type.errors.full_messages.join('<br />')
        redirect_to("/asset_types") and return
      end
    end
    @asset_types = AssetType.order("asset_type_id DESC")
  end

  def update_asset_type
    asset_type = AssetType.find(params[:asset_type_id])
    asset_type.name = params[:name]
    if asset_type.save
      person_id_param = "1" #TODO
      action_params = "Update"
      description_param = "Updated asset type record: #{asset_type.name}"
      SystemActivity.log(person_id_param, action_params, description_param)

      flash[:notice] = 'Record update was successful'
      redirect_to("/asset_types") and return
    else
      flash[:error] = asset_type.errors.full_messages.join('<br />')
      redirect_to("/asset_types") and return
    end
  end

  def delete_asset_type
    asset_type = AssetType.find(params[:id])
    if asset_type.delete
      person_id_param = "1" #TODO
      action_params = "Delete"
      description_param = "Deleted asset_type record: #{asset_type.name}"
      SystemActivity.log(person_id_param, action_params, description_param)

      flash[:notice] = 'Record deletion was successful'
      redirect_to("/asset_types") and return
    else
      flash[:error] = asset_type.errors.full_messages.join('<br />')
      redirect_to("/asset_types") and return
    end
  end

  def service_asset
    asset_service_log = AssetServiceLog.new
    asset_service_log.asset_id = params[:asset_id]
    asset_service_log.service_item_id = params[:selection_field_id]
    asset_service_log.performed_by = params[:service_performer]
    asset_service_log.person_id = params[:person_id] if params[:service_performer].to_s.downcase == "member"
    asset_service_log.vendor_id = params[:vendor_id] if params[:service_performer].to_s.downcase == "vendor"
    asset_service_log.notes = params[:comments]

    if params[:availability] == "maintenance"
      asset_service_log.state = 'Started'
      asset_service_log.start_date_actual = Time.now
      asset_service_log.start_date_expected = Time.now
      asset_service_log.end_date_expected = params[:completion_date]
      if params[:completion_date].to_date < Date.today
        flash[:error] = "Expected completion should be a future date"
        redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
      end
      if params[:service_indefinite].to_s == "on"
        asset_service_log.service_indefinite = 1
        asset_service_log.end_date_expected = ""
      end
    end

    if params[:availability] == "available"
      asset_service_log.state = 'Completed'
      asset_service_log.start_date_actual = params[:from]
      asset_service_log.start_date_expected = params[:from]
      asset_service_log.end_date_actual = params[:to]
      asset_service_log.end_date_expected = params[:to]
    end

    if asset_service_log.save
      person_id_param = "1" #TODO
      action_params = "Add"
      description_param = "Created new service log record: #{asset_service_log.state}"
      SystemActivity.log(person_id_param, action_params, description_param)

      flash[:notice] = 'Record update was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_service_log.errors.full_messages.join('<br />')
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

  def complete_service
    started_services = AssetServiceLog.where(['state =? AND asset_id=?', 'Started', params[:asset_id]])
    started_services.each do |service|
      service.state = 'Completed'
      service.end_date_actual = Time.now
      service.save

      person_id_param = "1" #TODO
      action_params = "Update"
      description_param = "Updated service record: #{service.state}"
      SystemActivity.log(person_id_param, action_params, description_param)
    end
    flash[:notice] = 'Record update was successful'
    redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
  end

  def extend_service
    started_service_logs = AssetServiceLog.where(['state =? AND asset_id =?', 'Started', params[:asset_id]])
    errors = []
    started_service_logs.each do |service_log|
      service_log.end_date_expected = params[:expected_completion]
      service_log.end_date_actual = ''
      if params[:service_indefinite].to_s == "on"
        service_log.service_indefinite = 1
        service_log.end_date_expected = ""
      end
      if service_log.save
        person_id_param = "1" #TODO
        action_params = "Update"
        description_param = "Extended service to: #{service_log.end_date_expected}"
        SystemActivity.log(person_id_param, action_params, description_param)
      else
        errors << service_log.errors.full_messages.join('<br />')
      end
    end
    unless errors.blank?
      flash[:error] = errors.join('<br />')
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    end
    flash[:notice] = 'Record update was successful'
    redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
  end

  def schedule_service
    asset_service_log = AssetServiceLog.new
    asset_service_log.asset_id = params[:asset_id]
    asset_service_log.service_item_id = params[:selection_field_id]
    asset_service_log.performed_by = params[:service_performer]
    asset_service_log.person_id = params[:person_id] if params[:service_performer].to_s.downcase == "member"
    asset_service_log.vendor_id = params[:vendor_id] if params[:service_performer].to_s.downcase == "vendor"
    asset_service_log.notes = params[:comments]
    asset_service_log.state = 'Scheduled'
    asset_service_log.start_date_expected = params[:expected_start_date]
    asset_service_log.end_date_expected = params[:expected_end_date]
    asset_service_log.available_on_date = 0 if params["make-item-unavailable"].to_s == "on"
    if asset_service_log.save
      person_id_param = "1" #TODO
      action_params = "Add"
      description_param = "Scheduled service: #{asset_service_log.start_date_expected} - #{asset_service_log.end_date_expected}"
      SystemActivity.log(person_id_param, action_params, description_param)

      flash[:notice] = 'Service schedule was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_service_log.errors.full_messages.join('<br />')
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

  def checkout_asset
    asset_activity = AssetActivity.new
    asset_activity.asset_id = params[:asset_id]
    asset_activity.name = 'Check-out'
    asset_activity.checkout_date = Time.now
    asset_activity.return_on = params[:return_date]
    if params["checkout-indefinite"].to_s == "on"
      asset_activity.checkout_indefinite = 1
      asset_activity.return_on = ""
    end
    asset_activity.person_id = params[:person_id]
    asset_activity.location_id = params[:location_id]
    asset_activity.notes = params[:comments]
    if asset_activity.save
      person_id_param = "1" #TODO
      action_params = "Checked out"
      description_param = "Checked out asset: #{asset_activity.asset_id}"
      SystemActivity.log(person_id_param, action_params, description_param)

      flash[:notice] = 'Checkout was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_activity.errors.full_messages.join('<br />')
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

  def extend_checkout
    #Check-out
    latest_asset_activity = AssetActivity.where(['asset_id =?', params[:asset_id]]).last
    unless latest_asset_activity.blank?
      if latest_asset_activity.name.downcase == "check-out"
        latest_asset_activity.return_on = params[:extend_date]
        if params["checkout-indefinite"].to_s == "on"
          latest_asset_activity.checkout_indefinite = 1
          latest_asset_activity.return_on = ""
        end
        if latest_asset_activity.save
          flash[:notice] = 'Checkout extension was successful'
          redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
        else
          flash[:error] = latest_asset_activity.errors.full_messages.join('<br />')
          redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
        end
      end
    end
    #ignore-clash-reservation TODO
  end

  def checkin_asset
    last_activity = AssetActivity.last_activity(params[:asset_id])
    checkout_activity = false
    unless last_activity.blank?
      checkout_activity = true if last_activity.name.to_s.downcase == "check-out"
    end
    asset_activity = AssetActivity.new
    asset_activity.asset_id = params[:asset_id]
    asset_activity.name = 'Check-in'
    asset_activity.checkin_date = params[:checkin_date]
    asset_activity.person_id = last_activity.person_id if checkout_activity
    asset_activity.location_id = params[:location_id]
    asset_activity.notes = params[:comments]
    if asset_activity.save
      person_id_param = "1" #TODO
      action_params = "Checkin"
      description_param = "Checked asset: #{asset_activity.asset_id}"
      SystemActivity.log(person_id_param, action_params, description_param)

      flash[:notice] = 'Checkin was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_activity.errors.full_messages.join('<br />')
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

  def reserve_asset
    asset_reservation = AssetReservation.new
    asset_reservation.asset_id = params[:asset_id]
    asset_reservation.start_date = params[:from]
    asset_reservation.end_date = params[:to]
    asset_reservation.person_id = params[:person_id]
    asset_reservation.location_id = params[:location_id]
    asset_reservation.notes = params[:comments]
    if asset_reservation.save
      person_id_param = "1" #TODO
      action_params = "Add"
      description_param = "Created new asset servation: #{asset_reservation.asset_id}"
      SystemActivity.log(person_id_param, action_params, description_param)

      flash[:notice] = 'Asset reservation was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_reservation.errors.full_messages.join('<br />')
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

  def activate_asset
    asset = Asset.find(params[:asset_id])
    asset.retired = 0
    asset.retire_reason = ""
    asset.date_retired = ""
    asset.retired_by = ""
    asset.retire_comments = ""
    if asset.save
      person_id_param = "1" #TODO
      action_params = "Activate"
      description_param = "Activate asset: #{asset.name}"
      SystemActivity.log(person_id_param, action_params, description_param)

      flash[:notice] = 'Asset activation was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset.errors.full_messages.join('<br />')
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

  def delete_asset_service_log
    asset_service_log = AssetServiceLog.find(params[:id])
    asset_id = asset_service_log.asset_id
    if asset_service_log.delete
      person_id_param = "1" #TODO
      action_params = "Delete"
      description_param = "Deleted service log record: #{asset_service_log.state}"
      SystemActivity.log(person_id_param, action_params, description_param)

      flash[:notice] = 'Record deletion was successful'
      redirect_to("/edit_asset?asset_id=#{asset_id}") and return
    else
      flash[:error] = "Unable to delete record"
      redirect_to("/edit_asset?asset_id=#{asset_id}") and return
    end
  end

  def start_scheduled_service
    asset_service_log = AssetServiceLog.find(params[:asset_service_log_id])
    asset_service_log.performed_by = params[:service_performer]
    asset_service_log.person_id = params[:person_id] if params[:service_performer].to_s.downcase == "member"
    asset_service_log.vendor_id = params[:vendor_id] if params[:service_performer].to_s.downcase == "vendor"
    asset_service_log.notes = params[:comments]
    asset_service_log.start_date_actual = Time.now
    asset_service_log.end_date_expected = params[:completion_date]

    if params[:availability] == "maintenance"
      asset_service_log.state = 'Started'
      if params[:completion_date].to_date < Date.today
        flash[:error] = "Expected completion should be a future date"
        redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
      end
      if params[:service_indefinite].to_s == "on"
        asset_service_log.service_indefinite = 1
        asset_service_log.end_date_expected = ""
      end
    end

    if params[:availability] == "available"
      asset_service_log.state = 'Completed'
    end

    if asset_service_log.save
      asset = Asset.find(params[:asset_id])
      asset.complete_all_started_services_except(params[:asset_service_log_id])
      flash[:notice] = 'Record update was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_service_log.errors.full_messages.join('<br />')
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

  def delete_asset_reservation
    asset_reservation = AssetReservation.find(params[:id])
    asset_id = asset_reservation.asset_id
    if asset_reservation.delete
      person_id_param = "1" #TODO
      action_params = "Delete"
      description_param = "Deleted asset reservation record"
      SystemActivity.log(person_id_param, action_params, description_param)

      flash[:notice] = 'Record deletion was successful'
      redirect_to("/edit_asset?asset_id=#{asset_id}") and return
    else
      flash[:error] = "Unable to delete record"
      redirect_to("/edit_asset?asset_id=#{asset_id}") and return
    end
  end

  def asset_label
    @asset = Asset.find(params[:asset_id])
    @barcode_base64 = @asset.generate_qr
    render layout: false
  end

  def download_asset_label
    asset_id = params[:asset_id]
    file_name = "asset-label-#{asset_id}.pdf"
    source = "http://#{request.env["HTTP_HOST"]}/asset_label?asset_id=#{asset_id}"
    destination = Rails.root.to_s + "/tmp/#{file_name}"
    wkhtmltopdf = "wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 #{source} #{destination}"
    Thread.new{
      Kernel.system wkhtmltopdf
    }.join
    send_file(destination)
  end

  def assets_summary_count
    summary = {
        "checked_out": 0,
        "maintenance": 0,
        "retired": 0,
        "available": 0
    }
    Asset.all.each do |asset|
      summary[:checked_out] += 1 if asset.state.to_s.match(/out/i)
      summary[:maintenance] += 1 if asset.state.to_s.match(/Maintenance/i)
      summary[:retired] += 1 if asset.state.to_s.match(/Retired/i)
      summary[:available] += 1 if asset.state.to_s.match(/Available/i)
    end

    respond_to do |format|
      format.json { render json: summary }
      format.html {}
    end
  end

end
