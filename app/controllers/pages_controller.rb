class PagesController < ApplicationController
  def home
    @page_header = "Dashboard"
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
  end

  def delete_asset
    asset = Asset.find(params[:id])
    asset_attachments = asset.asset_attachments
    errors = []
    ActiveRecord::Base.transaction do
      if asset.delete
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
      flash[:notice] = 'Record update was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_service_log.errors.full_messages.join('<br />')
      redirect_to("/dit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

  def complete_service
    started_services = AssetServiceLog.where(['state =? AND asset_id=?', 'Started', params[:asset_id]])
    started_services.each do |service|
      service.state = 'Completed'
      service.end_date_actual = Time.now
      service.save
    end
    flash[:notice] = 'Record update was successful'
    redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
  end

  def extend_service
    started_service_logs = AssetServiceLog.where(['state =? AND asset_id =?', 'Started', params[:asset_id]])
    started_service_logs.each do |service_log|
      service_log.end_date_expected = params[:expected_completion]
      service_log.end_date_actual = ''
      if params[:service_indefinite].to_s == "on"
        service_log.service_indefinite = 1
        service_log.end_date_expected = ""
      end
      service_log.save
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
      flash[:notice] = 'Service schedule was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_service_log.errors.full_messages.join('<br />')
      redirect_to("/dit_asset?asset_id=#{params[:asset_id]}") and return
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
      flash[:notice] = 'Checkout was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_activity.errors.full_messages.join('<br />')
      redirect_to("/dit_asset?asset_id=#{params[:asset_id]}") and return
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
          redirect_to("/dit_asset?asset_id=#{params[:asset_id]}") and return
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
      flash[:notice] = 'Checkin was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_activity.errors.full_messages.join('<br />')
      redirect_to("/dit_asset?asset_id=#{params[:asset_id]}") and return
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
      flash[:notice] = 'Asset reservation was successful'
      redirect_to("/edit_asset?asset_id=#{params[:asset_id]}") and return
    else
      flash[:error] = asset_reservation.errors.full_messages.join('<br />')
      redirect_to("/dit_asset?asset_id=#{params[:asset_id]}") and return
    end
  end

end
