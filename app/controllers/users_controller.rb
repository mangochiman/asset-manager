class UsersController < ApplicationController
  before_action :authorize, :except => [:login, :logout, :check_if_email_exists, :reset_password]

  def login
    if request.post?
      user = User.find_by_username(params['username'])
      logged_in_user = User.authenticate(params[:username], params[:password])
      if logged_in_user
        session[:user] = user
        redirect_to('/') and return
      else
        flash[:error] = 'Invalid username or password'
        redirect_to('/login') and return
      end
    end
    active_system_plan = SystemPlan.active_plan
    @company_name = active_system_plan.company_name rescue ""
    render layout: false
  end

  def authenticate
    data = User.authenticate(params[:username], params[:password])
    render json: data.to_json
  end

  def my_profile
    @page_header = 'My profile'
  end

  def update_profile
    user = User.find(session[:user]['user_id'])
    user.username = params[:user][:username]
    if user.save
      person = user.person
      person.first_name = params[:person][:first_name]
      person.last_name = params[:person][:last_name]
      person.email = params[:person][:email]
      person.phone = params[:person][:phone]
      if person.save
        flash[:notice] = 'Account was updated successfully'
        redirect_to('/my_profile') and return
      else
        flash[:error] = person.errors.full_messages.join('<br />')
        redirect_to('/my_profile') and return
      end
    else
      flash[:error] = user.errors.full_messages.join('<br />')
      redirect_to('/my_profile') and return
    end

  end

  def update_password
    user = User.find(session[:user]['user_id'])
    if (User.authenticate(user.username, params[:old_password]))
      if (params[:new_password] == params[:confirm_password])
        user.password = User.encrypt(params[:new_password], user.salt)
        if (user.save)
          flash[:notice] = "You have successfully updated your password. Your new password is <b>#{params[:new_password]}</b>"
          redirect_to('/my_profile') and return
        else
          flash[:error] = user.errors.full_messages.join('<br />')
          redirect_to('/my_profile') and return
        end
      else
        flash[:error] = 'Password update failed. New password and confirmation password does not match'
        redirect_to('/my_profile') and return
      end
    else
      flash[:error] = 'Password update failed. Old password is not correct'
      redirect_to('/my_profile') and return
    end
  end

  def new_user
    @page_header = 'New user'
    @roles = User.roles
    if request.post?
      password = params[:user][:password]
      password_confirm = params[:user][:confirm_password]

      if (password != password_confirm)
        flash[:error] = 'Password Mismatch'
        redirect_to('/new_user') and return
      end
      user = User.new_user(params)

      if user.save
        UserRole.create_user_role(user, params)

        flash[:notice] = 'Account creation was successful'
        redirect_to('/new_user') and return
      else
        flash[:error] = user.errors.full_messages.join('<br />')
        redirect_to('/new_user') and return
      end
    end
  end

  def edit_user
    @page_header = 'Edit user'
    @users = User.all
  end

  def view_users
    @page_header = 'View users'
    @users = User.all
  end

  def void_users
    @page_header = 'Void users'
    @users = User.all
    if request.post?
      user = User.find(params[:user_id])
      user.void_user(params)
      if user.save
        flash[:notice] = "#{user.username} has been voided"
      else
        flash[:error] = user.errors.full_messages.join('<br />')
      end
      redirect_to('/void_users') and return
    end
  end

  def check_if_email_exists
    user = User.joins(:person).where(["email =?", params[:email]]).last
    render json: user.to_json
  end

  def reset_password
    user = User.joins(:person).where(["email =?", params[:email]]).last
    new_password = user.reset_password
    NotificationMailer.reset_password(user.person, new_password).deliver_later
    render json: {success: true}.to_json
  end

  def logout
    reset_session #Destroy all sessions
    flash[:notice] = "You have been logged out"
    redirect_to('/login') and return
  end
end
