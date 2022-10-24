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
end
