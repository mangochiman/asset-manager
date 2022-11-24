require 'csv'
require 'write_xlsx'

class ReportsController < ApplicationController
  def asset_list
    @page_header = "Asset List Report"
    @assets = Asset.all
  end

  def asset_list_csv
    assets = Asset.all
    file = "#{Rails.root}/tmp/asset_list.csv"
    headers = ["Asset Name", "Asset Number", "Location", "Status", "Brand", "Model", "Last Update"]
    CSV.open(file, 'w', write_headers: true, headers: headers) do |csv|
      assets.each do |asset|
        csv << [asset.name, asset.barcode, asset.location_details, asset.state, asset.brand, asset.model, asset.updated_at.strftime("%d.%m.%Y")]
      end
    end
    send_file(file)
  end

  def asset_list_work_book
    assets = Asset.all
    file = "#{Rails.root}/tmp/asset_list.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet
    # Add and define a format
    row_pos = 0
    worksheet.write(row_pos, 0, "Asset Name")
    worksheet.write(row_pos, 1, "Asset Number")
    worksheet.write(row_pos, 2, "Location")
    worksheet.write(row_pos, 3, "Status")
    worksheet.write(row_pos, 4, "Brand")
    worksheet.write(row_pos, 5, "Model")
    worksheet.write(row_pos, 6, "Last Update")

    assets.each do |asset|
      row_pos = row_pos + 1
      updated_at = asset.updated_at.strftime("%d.%m.%Y")
      worksheet.write(row_pos, 0, asset.name)
      worksheet.write(row_pos, 1, asset.barcode)
      worksheet.write(row_pos, 2, asset.location_details)
      worksheet.write(row_pos, 3, asset.state)
      worksheet.write(row_pos, 4, asset.brand)
      worksheet.write(row_pos, 5, asset.model)
      worksheet.write(row_pos, 6, updated_at)
    end
    # write to file
    workbook.close
    send_file(file)
  end

  def asset_list_pdf
    @page_header = "Asset List Report"
    report_option = ReportOption.last
    @header = report_option.header rescue nil
    @footer = report_option.footer rescue nil
    @logo_url = report_option.logo_url rescue nil
    @assets = Asset.all
  end

  def download_asset_list_pdf
    file_name = "asset-list.pdf"
    source = "http://#{request.env["HTTP_HOST"]}/asset_list_pdf"
    destination = Rails.root.to_s + "/tmp/#{file_name}"
    wkhtmltopdf = "xvfb-run wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 #{source} #{destination}"
    Thread.new{
      Kernel.system wkhtmltopdf
    }.join
    send_file(destination)
  end

  def asset_details
    @page_header = "Asset Details"
    @assets = Asset.all
  end

  def asset_details_pdf
    @page_header = "Asset Details Report"
    report_option = ReportOption.last
    @header = report_option.header rescue nil
    @footer = report_option.footer rescue nil
    @logo_url = report_option.logo_url rescue nil
    @assets = Asset.all
  end

  def download_asset_details_pdf
    file_name = "asset-details.pdf"
    source = "http://#{request.env["HTTP_HOST"]}/asset_details_pdf"
    destination = Rails.root.to_s + "/tmp/#{file_name}"
    wkhtmltopdf = "xvfb-run wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 #{source} #{destination}"
    Thread.new{
      Kernel.system wkhtmltopdf
    }.join
    send_file(destination)
  end

  def assets_checked_out
    @page_header = "Assets Checked Out"
    @assets = Asset.checked_out
  end

  def assets_checked_out_csv
    assets = Asset.checked_out
    file = "#{Rails.root}/tmp/assets_checked_out.csv"
    headers = ["Asset Name", "Asset Number", "Location", "Status", "Brand", "Model",
               "Checked Out Date", "Return On"]
    CSV.open(file, 'w', write_headers: true, headers: headers) do |csv|
      assets.each do |asset|
        csv << [asset.name, asset.barcode, asset.location_details, asset.state, asset.brand, asset.model,
                asset.checked_out_date.strftime("%d.%m.%Y"), asset.return_on_date.strftime("%d.%m.%Y")  ]
      end
    end
    send_file(file)
  end

  def assets_checked_out_work_book
    assets = Asset.checked_out
    file = "#{Rails.root}/tmp/assets_checked_out.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet
    # Add and define a format
    row_pos = 0
    worksheet.write(row_pos, 0, "Asset Name")
    worksheet.write(row_pos, 1, "Asset Number")
    worksheet.write(row_pos, 2, "Location")
    worksheet.write(row_pos, 3, "Status")
    worksheet.write(row_pos, 4, "Brand")
    worksheet.write(row_pos, 5, "Model")
    worksheet.write(row_pos, 6, "Checked Out Date")
    worksheet.write(row_pos, 7, "Return On")

    assets.each do |asset|
      row_pos = row_pos + 1
      checked_out_date = asset.checked_out_date.strftime("%d.%m.%Y")
      return_on = asset.return_on_date.strftime("%d.%m.%Y")
      worksheet.write(row_pos, 0, asset.name)
      worksheet.write(row_pos, 1, asset.barcode)
      worksheet.write(row_pos, 2, asset.location_details)
      worksheet.write(row_pos, 3, asset.state)
      worksheet.write(row_pos, 4, asset.brand)
      worksheet.write(row_pos, 5, asset.model)
      worksheet.write(row_pos, 6, checked_out_date)
      worksheet.write(row_pos, 7, return_on)
    end
    # write to file
    workbook.close
    send_file(file)
  end

  def assets_checked_out_pdf
    @page_header = "Assets Checked Out Report"
    report_option = ReportOption.last
    @header = report_option.header rescue nil
    @footer = report_option.footer rescue nil
    @logo_url = report_option.logo_url rescue nil
    @assets = Asset.checked_out
  end

  def download_assets_checked_out_pdf
    file_name = "assets-checked-out.pdf"
    source = "http://#{request.env["HTTP_HOST"]}/assets_checked_out_pdf"
    destination = Rails.root.to_s + "/tmp/#{file_name}"
    wkhtmltopdf = "xvfb-run wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 #{source} #{destination}"
    Thread.new{
      Kernel.system wkhtmltopdf
    }.join
    send_file(destination)
  end

  def personnel_list
    @page_header = "Personnel List Report"
    @people = Person.all
  end

  def personnel_list_csv
    people = Person.all
    file = "#{Rails.root}/tmp/personnel-list.csv"
    headers = ["First Name", "Last Name", "Personnel Number", "Email", "Phone Number", "Date Updated"]
    CSV.open(file, 'w', write_headers: true, headers: headers) do |csv|
      people.each do |person|
        updated_at = person.updated_at.strftime("%d.%m.%Y") rescue person.updated_at
        csv << [person.first_name, person.last_name, person.barcode, person.email, person.phone, updated_at]
      end
    end
    send_file(file)
  end

  def personnel_list_work_book
    people = Person.all
    file = "#{Rails.root}/tmp/personnel-list.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet
    # Add and define a format
    row_pos = 0
    worksheet.write(row_pos, 0, "First Name")
    worksheet.write(row_pos, 1, "Last Name")
    worksheet.write(row_pos, 2, "Personnel Number")
    worksheet.write(row_pos, 3, "Email")
    worksheet.write(row_pos, 4, "Phone Number")
    worksheet.write(row_pos, 5, "Date Updated")

    people.each do |person|
      row_pos = row_pos + 1
      updated_at = person.updated_at.strftime("%d.%m.%Y") rescue person.updated_at
      worksheet.write(row_pos, 0, person.first_name)
      worksheet.write(row_pos, 1, person.last_name)
      worksheet.write(row_pos, 2, person.barcode)
      worksheet.write(row_pos, 3, person.email)
      worksheet.write(row_pos, 4, person.phone)
      worksheet.write(row_pos, 5, updated_at)
    end
    # write to file
    workbook.close
    send_file(file)
  end

  def personnel_list_pdf
    @page_header = "Personnel List Report"
    report_option = ReportOption.last
    @header = report_option.header rescue nil
    @footer = report_option.footer rescue nil
    @logo_url = report_option.logo_url rescue nil
    @people = Person.all
  end

  def download_personnel_list_pdf
    file_name = "personnel-list.pdf"
    source = "http://#{request.env["HTTP_HOST"]}/personnel_list_pdf"
    destination = Rails.root.to_s + "/tmp/#{file_name}"
    wkhtmltopdf = "xvfb-run wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 #{source} #{destination}"
    Thread.new{
      Kernel.system wkhtmltopdf
    }.join
    send_file(destination)
  end

  def vendor_list
    @page_header = "Vendor List Report"
    @vendors = Vendor.all
  end

  def vendor_list_csv
    vendors = Vendor.all
    file = "#{Rails.root}/tmp/vendor-list.csv"
    headers = ["Name", "Number", "Phone #", "Contact Name", "Email", "Last Update"]
    CSV.open(file, 'w', write_headers: true, headers: headers) do |csv|
      vendors.each do |vendor|
        updated_at = vendor.updated_at.strftime("%d.%m.%Y") rescue vendor.updated_at
        csv << [vendor.name, vendor.number, vendor.phone, vendor.contact_name, vendor.email, updated_at]
      end
    end
    send_file(file)
  end

  def vendor_list_work_book
    vendors = Vendor.all
    file = "#{Rails.root}/tmp/vendor-list.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet
    # Add and define a format
    row_pos = 0
    worksheet.write(row_pos, 0, "Name")
    worksheet.write(row_pos, 1, "Number")
    worksheet.write(row_pos, 2, "Phone #")
    worksheet.write(row_pos, 3, "Contact Name")
    worksheet.write(row_pos, 4, "Email")
    worksheet.write(row_pos, 5, "Last Update")

    vendors.each do |vendor|
      row_pos = row_pos + 1
      updated_at = vendor.updated_at.strftime("%d.%m.%Y") rescue vendor.updated_at
      worksheet.write(row_pos, 0, vendor.name)
      worksheet.write(row_pos, 1, vendor.number)
      worksheet.write(row_pos, 2, vendor.phone)
      worksheet.write(row_pos, 3, vendor.contact_name)
      worksheet.write(row_pos, 4, vendor.email)
      worksheet.write(row_pos, 5, updated_at)
    end
    # write to file
    workbook.close
    send_file(file)
  end

  def vendor_list_pdf
    @page_header = "Vendor List Report"
    report_option = ReportOption.last
    @header = report_option.header rescue nil
    @footer = report_option.footer rescue nil
    @logo_url = report_option.logo_url rescue nil
    @vendors = Vendor.all
  end

  def download_vendor_list_pdf
    file_name = "vendor-list.pdf"
    source = "http://#{request.env["HTTP_HOST"]}/vendor_list_pdf"
    destination = Rails.root.to_s + "/tmp/#{file_name}"
    wkhtmltopdf = "xvfb-run wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 #{source} #{destination}"
    Thread.new{
      Kernel.system wkhtmltopdf
    }.join
    send_file(destination)
  end

  def completed_service
    @page_header = "Completed Service Report"
    @completed_services = AssetServiceLog.completed_service
  end

  def completed_services_csv
    completed_services = AssetServiceLog.completed_service
    file = "#{Rails.root}/tmp/completed-services.csv"
    headers = ["Asset Name", "Start Date Expected", "Start Date Actual", "End Date Expected", "End Date Actual", "Service Type", "Notes"]
    CSV.open(file, 'w', write_headers: true, headers: headers) do |csv|
      completed_services.each do |asset_service_log|
        start_date_expected = asset_service_log.start_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.start_date_expected
        start_date_actual = asset_service_log.start_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.start_date_actual
        end_date_expected = asset_service_log.end_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.end_date_expected
        end_date_actual = asset_service_log.end_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.end_date_actual

        csv << [asset_service_log.asset_details, start_date_expected, start_date_actual, end_date_expected, end_date_actual, asset_service_log.service_type_details, asset_service_log.notes]
      end
    end
    send_file(file)
  end

  def completed_services_work_book
    completed_services = AssetServiceLog.completed_service
    file = "#{Rails.root}/tmp/completed-services.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet

    row_pos = 0
    worksheet.write(row_pos, 0, "Asset Name")
    worksheet.write(row_pos, 1, "Start Date Expected")
    worksheet.write(row_pos, 2, "Start Date Actual")
    worksheet.write(row_pos, 3, "End Date Expected")
    worksheet.write(row_pos, 4, "End Date Actual")
    worksheet.write(row_pos, 5, "Service Type")
    worksheet.write(row_pos, 6, "Notes")

    completed_services.each do |asset_service_log|
      row_pos = row_pos + 1
      start_date_expected = asset_service_log.start_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.start_date_expected
      start_date_actual = asset_service_log.start_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.start_date_actual
      end_date_expected = asset_service_log.end_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.end_date_expected
      end_date_actual = asset_service_log.end_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.end_date_actual

      worksheet.write(row_pos, 0, asset_service_log.asset_details)
      worksheet.write(row_pos, 1, start_date_expected)
      worksheet.write(row_pos, 2, start_date_actual)
      worksheet.write(row_pos, 3, end_date_expected)
      worksheet.write(row_pos, 4, end_date_actual)
      worksheet.write(row_pos, 5, asset_service_log.service_type_details)
      worksheet.write(row_pos, 6, asset_service_log.notes)
    end
    # write to file
    workbook.close
    send_file(file)
  end

  def completed_services_pdf
    @page_header = "Completed Services Report"
    @completed_services = AssetServiceLog.completed_service
    report_option = ReportOption.last
    @header = report_option.header rescue nil
    @footer = report_option.footer rescue nil
    @logo_url = report_option.logo_url rescue nil
  end

  def download_completed_services_pdf
    file_name = "completed-services.pdf"
    source = "http://#{request.env["HTTP_HOST"]}/completed_services_pdf"
    destination = Rails.root.to_s + "/tmp/#{file_name}"
    wkhtmltopdf = "xvfb-run wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 #{source} #{destination}"
    Thread.new{
      Kernel.system wkhtmltopdf
    }.join
    send_file(destination)
  end

  def overdue_service
    @page_header = "Overdue Service Report"
    @overdue_service = AssetServiceLog.overdue_service
  end

  def overdue_services_csv
    overdue_services = AssetServiceLog.overdue_service
    file = "#{Rails.root}/tmp/overdue-services.csv"
    headers = ["Asset Name", "Start Date Expected", "Start Date Actual", "End Date Expected", "End Date Actual", "Service Type", "Notes"]
    CSV.open(file, 'w', write_headers: true, headers: headers) do |csv|
      overdue_services.each do |asset_service_log|
        start_date_expected = asset_service_log.start_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.start_date_expected
        start_date_actual = asset_service_log.start_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.start_date_actual
        end_date_expected = asset_service_log.end_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.end_date_expected
        end_date_actual = asset_service_log.end_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.end_date_actual

        csv << [asset_service_log.asset_details, start_date_expected, start_date_actual, end_date_expected, end_date_actual, asset_service_log.service_type_details, asset_service_log.notes]
      end
    end
    send_file(file)
  end

  def overdue_services_work_book
    overdue_services = AssetServiceLog.overdue_service
    file = "#{Rails.root}/tmp/overdue-services.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet

    row_pos = 0
    worksheet.write(row_pos, 0, "Asset Name")
    worksheet.write(row_pos, 1, "Start Date Expected")
    worksheet.write(row_pos, 2, "Start Date Actual")
    worksheet.write(row_pos, 3, "End Date Expected")
    worksheet.write(row_pos, 4, "End Date Actual")
    worksheet.write(row_pos, 5, "Service Type")
    worksheet.write(row_pos, 6, "Notes")

    overdue_services.each do |asset_service_log|
      row_pos = row_pos + 1
      start_date_expected = asset_service_log.start_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.start_date_expected
      start_date_actual = asset_service_log.start_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.start_date_actual
      end_date_expected = asset_service_log.end_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.end_date_expected
      end_date_actual = asset_service_log.end_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.end_date_actual

      worksheet.write(row_pos, 0, asset_service_log.asset_details)
      worksheet.write(row_pos, 1, start_date_expected)
      worksheet.write(row_pos, 2, start_date_actual)
      worksheet.write(row_pos, 3, end_date_expected)
      worksheet.write(row_pos, 4, end_date_actual)
      worksheet.write(row_pos, 5, asset_service_log.service_type_details)
      worksheet.write(row_pos, 6, asset_service_log.notes)
    end
    # write to file
    workbook.close
    send_file(file)
  end

  def overdue_services_pdf
    @page_header = "Overdue Services Report"
    @overdue_services = AssetServiceLog.overdue_service
    report_option = ReportOption.last
    @header = report_option.header rescue nil
    @footer = report_option.footer rescue nil
    @logo_url = report_option.logo_url rescue nil
  end

  def download_overdue_services_pdf
    file_name = "overdue-services.pdf"
    source = "http://#{request.env["HTTP_HOST"]}/overdue_services_pdf"
    destination = Rails.root.to_s + "/tmp/#{file_name}"
    wkhtmltopdf = "xvfb-run wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 #{source} #{destination}"
    Thread.new{
      Kernel.system wkhtmltopdf
    }.join
    send_file(destination)
  end

  def service_schedule
    @page_header = "Service Schedule Report"
    @scheduled_services = AssetServiceLog.service_schedule
  end

  def service_schedule_csv
    scheduled_services = AssetServiceLog.service_schedule
    file = "#{Rails.root}/tmp/scheduled-services.csv"
    headers = ["Asset Name", "Start Date Expected", "Start Date Actual", "End Date Expected", "End Date Actual", "Service Type", "Notes"]
    CSV.open(file, 'w', write_headers: true, headers: headers) do |csv|
      scheduled_services.each do |asset_service_log|
        start_date_expected = asset_service_log.start_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.start_date_expected
        start_date_actual = asset_service_log.start_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.start_date_actual
        end_date_expected = asset_service_log.end_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.end_date_expected
        end_date_actual = asset_service_log.end_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.end_date_actual

        csv << [asset_service_log.asset_details, start_date_expected, start_date_actual, end_date_expected, end_date_actual, asset_service_log.service_type_details, asset_service_log.notes]
      end
    end
    send_file(file)
  end

  def service_schedule_work_book
    scheduled_services = AssetServiceLog.service_schedule
    file = "#{Rails.root}/tmp/scheduled-services.xlsx"
    workbook = WriteXLSX.new(file)
    worksheet = workbook.add_worksheet

    row_pos = 0
    worksheet.write(row_pos, 0, "Asset Name")
    worksheet.write(row_pos, 1, "Start Date Expected")
    worksheet.write(row_pos, 2, "Start Date Actual")
    worksheet.write(row_pos, 3, "End Date Expected")
    worksheet.write(row_pos, 4, "End Date Actual")
    worksheet.write(row_pos, 5, "Service Type")
    worksheet.write(row_pos, 6, "Notes")

    scheduled_services.each do |asset_service_log|
      row_pos = row_pos + 1
      start_date_expected = asset_service_log.start_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.start_date_expected
      start_date_actual = asset_service_log.start_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.start_date_actual
      end_date_expected = asset_service_log.end_date_expected.strftime("%d.%m.%Y") rescue asset_service_log.end_date_expected
      end_date_actual = asset_service_log.end_date_actual.strftime("%d.%m.%Y") rescue asset_service_log.end_date_actual

      worksheet.write(row_pos, 0, asset_service_log.asset_details)
      worksheet.write(row_pos, 1, start_date_expected)
      worksheet.write(row_pos, 2, start_date_actual)
      worksheet.write(row_pos, 3, end_date_expected)
      worksheet.write(row_pos, 4, end_date_actual)
      worksheet.write(row_pos, 5, asset_service_log.service_type_details)
      worksheet.write(row_pos, 6, asset_service_log.notes)
    end
    # write to file
    workbook.close
    send_file(file)
  end

  def service_schedule_pdf
    @page_header = "Service Schedule Report"
    @scheduled_services = AssetServiceLog.service_schedule
    report_option = ReportOption.last
    @header = report_option.header rescue nil
    @footer = report_option.footer rescue nil
    @logo_url = report_option.logo_url rescue nil
  end

  def download_service_schedule_pdf
    file_name = "scheduled-services.pdf"
    source = "http://#{request.env["HTTP_HOST"]}/service_schedule_pdf"
    destination = Rails.root.to_s + "/tmp/#{file_name}"
    wkhtmltopdf = "xvfb-run wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 #{source} #{destination}"
    Thread.new{
      Kernel.system wkhtmltopdf
    }.join
    send_file(destination)
  end

end
