Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'pages#home'

  get '/login' => 'users#login'
  post '/login' => 'users#login'
  get '/logout' => 'users#logout'

  get '/new_user' => 'users#new_user'
  get '/my_profile' => 'users#my_profile'
  post '/update_profile' => 'users#update_profile'
  post '/update_password' => 'users#update_password'
  post '/new_user' => 'users#new_user'
  get '/edit_user' => 'users#edit_user'
  post '/edit_user' => 'users#edit_user'
  get '/view_users' => 'users#view_users'
  post '/view_users' => 'users#view_users'
  get '/void_users' => 'users#void_users'
  post '/void_users' => 'users#void_users'
  get '/check_if_email_exists' => 'users#check_if_email_exists'
  get '/reset_password' => 'users#reset_password'

  #new_asset_menu
  get '/new_asset_menu' => 'pages#new_asset_menu'
  post '/new_asset_menu' => 'pages#new_asset_menu'

  get '/upload_assets_from_file' => 'pages#upload_assets_from_file'
  post '/upload_assets_from_file' => 'pages#upload_assets_from_file'
  get '/download_asset_template' => 'pages#download_asset_template'

  get '/system_overview' => 'pages#system_overview' #selection_fields
  post '/system_overview' => 'pages#system_overview'

  get '/selection_fields' => 'pages#selection_fields'
  post '/selection_fields' => 'pages#selection_fields' #service_items update_selection_field
  post '/update_selection_field' => 'pages#update_selection_field' #delete_selection_field
  post '/delete_selection_field' => 'pages#delete_selection_field'

  get '/service_items' => 'pages#service_items'
  post '/service_items' => 'pages#service_items' #report_options update_service_item
  post '/update_service_item' => 'pages#update_service_item' #delete_service_item
  post '/delete_service_item' => 'pages#delete_service_item'

  get '/report_options' => 'pages#report_options'
  post '/report_options' => 'pages#report_options' #export_all

  get '/export_all' => 'pages#export_all'
  post '/export_all' => 'pages#export_all'

  get '/new_vendor' => 'pages#new_vendor'
  post '/new_vendor' => 'pages#new_vendor' #list_vendors delete_vendor
  post '/delete_vendor' => 'pages#delete_vendor'

  get '/list_vendors' => 'pages#list_vendors' #edit_vendor
  get '/edit_vendor' => 'pages#edit_vendor'
  post '/edit_vendor' => 'pages#edit_vendor'

  post '/delete_vendor_attachment' => 'pages#delete_vendor_attachment' #groups
  get '/groups' => 'pages#groups'
  post '/groups' => 'pages#groups' #update_group
  post '/update_group' => 'pages#update_group'
  post '/delete_group' => 'pages#delete_group'

  get '/locations' => 'pages#locations'
  post '/locations' => 'pages#locations'
  post '/delete_location' => 'pages#delete_location'
  post '/update_location' => 'pages#update_location' #new_person

  get '/new_person' => 'pages#new_person'
  post '/new_person' => 'pages#new_person' #edit_person

  get '/edit_person' => 'pages#edit_person'
  post '/edit_person' => 'pages#edit_person'

  get '/list_people' => 'pages#list_people' #delete_person
  post '/delete_person' => 'pages#delete_person'
  post '/delete_person_attachment' => 'pages#delete_person_attachment'

  #asset_types
  get '/asset_types' => 'pages#asset_types'
  post '/asset_types' => 'pages#asset_types'
  post '/update_asset_type' => 'pages#update_asset_type'
  post '/delete_asset_type' => 'pages#delete_asset_type'
  get '/list_assets' => 'pages#list_assets'
  get '/edit_asset' => 'pages#edit_asset'
  post '/edit_asset' => 'pages#edit_asset'
  post '/delete_asset_attachment' => 'pages#delete_asset_attachment'
  post '/delete_asset' => 'pages#delete_asset'
  post '/retire_asset' => 'pages#retire_asset'

  post '/service_asset' => 'pages#service_asset'
  post '/complete_service' => 'pages#complete_service'
  post '/extend_service' => 'pages#extend_service'
  post '/schedule_service' => 'pages#schedule_service'
  post '/checkout_asset' => 'pages#checkout_asset'
  post '/extend_checkout' => 'pages#extend_checkout'
  post '/checkin_asset' => 'pages#checkin_asset'
  post '/reserve_asset' => 'pages#reserve_asset'
  post '/activate_asset' => 'pages#activate_asset'
  post '/delete_asset_service_log' => 'pages#delete_asset_service_log'
  post '/start_scheduled_service' => 'pages#start_scheduled_service'
  post '/delete_asset_reservation' => 'pages#delete_asset_reservation'
  get '/asset_label' => 'pages#asset_label'
  get '/download_asset_label' => 'pages#download_asset_label'
  post '/assets_summary_count' => 'pages#assets_summary_count'
  post '/items_count' => 'pages#items_count'
  post '/check_in_out_activity_summary' => 'pages#check_in_out_activity_summary'
  get '/files' => 'pages#files'
  post '/delete_file' => 'pages#delete_file'
  get '/download_file' => 'pages#download_file'
  get '/list_system_activities' => 'pages#list_system_activities'
  get '/assets_by_state' => 'pages#assets_by_state'
  get '/export_data' => 'pages#export_data'
  get '/export_files' => 'pages#export_files'
  get '/download_export_record' => 'pages#download_export_record'
  get '/subscription_plan_summary' => 'pages#subscription_plan_summary'
  post '/subscription_plan_summary' => 'pages#subscription_plan_summary'
  get '/package_expired' => 'pages#package_expired'
  get '/pricing' => 'pages#pricing'
  #projects
  get '/projects' => 'pages#projects'
  post '/projects' => 'pages#projects'
  post '/update_project' => 'pages#update_project'
  post '/delete_project' => 'pages#delete_project'

  #reports
  get '/asset_list' => 'reports#asset_list'
  get '/asset_list_csv' => 'reports#asset_list_csv'
  get '/asset_list_work_book' => 'reports#asset_list_work_book'
  get '/asset_list_pdf' => 'reports#asset_list_pdf'
  get '/download_asset_list_pdf' => 'reports#download_asset_list_pdf'

  get '/asset_details' => 'reports#asset_details' #asset_details_pdf

  get '/asset_details_pdf' => 'reports#asset_details_pdf'
  get '/download_asset_details_pdf' => 'reports#download_asset_details_pdf'

  get '/assets_checked_out' => 'reports#assets_checked_out'
  get '/assets_checked_out_csv' => 'reports#assets_checked_out_csv'
  get '/assets_checked_out_work_book' => 'reports#assets_checked_out_work_book'
  get '/assets_checked_out_pdf' => 'reports#assets_checked_out_pdf'
  get '/download_assets_checked_out_pdf' => 'reports#download_assets_checked_out_pdf'

  get '/personnel_list' => 'reports#personnel_list'
  get '/personnel_list_csv' => 'reports#personnel_list_csv'
  get '/personnel_list_work_book' => 'reports#personnel_list_work_book'
  get '/personnel_list_pdf' => 'reports#personnel_list_pdf'
  get '/download_personnel_list_pdf' => 'reports#download_personnel_list_pdf'

  get '/vendor_list' => 'reports#vendor_list'
  get '/vendor_list_csv' => 'reports#vendor_list_csv'
  get '/vendor_list_work_book' => 'reports#vendor_list_work_book'
  get '/vendor_list_pdf' => 'reports#vendor_list_pdf'
  get '/download_vendor_list_pdf' => 'reports#download_vendor_list_pdf'

  get '/completed_service' => 'reports#completed_service'
  get '/completed_services_csv' => 'reports#completed_services_csv'
  get '/completed_services_work_book' => 'reports#completed_services_work_book'
  get '/completed_services_pdf' => 'reports#completed_services_pdf'
  get '/download_completed_services_pdf' => 'reports#download_completed_services_pdf'

  get '/overdue_service' => 'reports#overdue_service'
  get '/overdue_services_csv' => 'reports#overdue_services_csv'
  get '/overdue_services_work_book' => 'reports#overdue_services_work_book'
  get '/overdue_services_pdf' => 'reports#overdue_services_pdf'
  get '/download_overdue_services_pdf' => 'reports#download_overdue_services_pdf'

  get '/service_schedule' => 'reports#service_schedule'
  get '/service_schedule_csv' => 'reports#service_schedule_csv'
  get '/service_schedule_work_book' => 'reports#service_schedule_work_book'
  get '/service_schedule_pdf' => 'reports#service_schedule_pdf'
  get '/download_service_schedule_pdf' => 'reports#download_service_schedule_pdf'

  get '/upload_people_from_file' => 'pages#upload_people_from_file'
  post '/upload_people_from_file' => 'pages#upload_people_from_file'
  get '/download_people_template' => 'pages#download_people_template'

  get '/person_checkin_out_history' => 'pages#person_checkin_out_history'

  get "/404", to: "errors#not_found", :via => :all
  post "/404", to: "errors#not_found", :via => :all
  get "/422", to: "errors#unacceptable", :via => :all
  post "/422", to: "errors#unacceptable", :via => :all
  get "/500", to: "errors#internal_error", :via => :all
  post "/500", to: "errors#internal_error", :via => :all
end
