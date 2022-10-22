class CreateReportOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :report_options, :primary_key => :report_option_id do |t|
      t.string :header
      t.string :footer
      t.string :logo_url
      t.timestamps
    end
  end
end
