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
    wkhtmltopdf = "wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 #{source} #{destination}"
    Thread.new{
      Kernel.system wkhtmltopdf
    }.join
    send_file(destination)
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
