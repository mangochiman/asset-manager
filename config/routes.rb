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

  get '/selection_fields' => 'pages#selection_fields'
  post '/selection_fields' => 'pages#selection_fields' #service_items

  get '/service_items' => 'pages#service_items'
  post '/service_items' => 'pages#service_items' #report_options

  get '/report_options' => 'pages#report_options'
  post '/report_options' => 'pages#report_options'

end
