require 'digest/sha1'
require 'digest/sha2'
class User < ActiveRecord::Base
  self.table_name = 'users'
  self.primary_key = 'user_id'

  has_many :password_reminders, :dependent => :destroy

  validates_presence_of :username, :message => ' can not be blank'
  validates_uniqueness_of :username, :message => ' already taken'
  belongs_to :person, :foreign_key => :person_id

  validate :admin_quota_validation

  default_scope {where('voided = 0')}

  def try_to_login
    User.authenticate(self.username, self.password)
  end

  def self.authenticate(login, password)
    password = password.to_s.squish
    u = where(['username =?', login]).first
    if u
      password_reminder = u.password_reminders.last
      unless password_reminder.blank?
        if (User.encrypt(password.squish, password_reminder.salt) == password_reminder.password)
          u.password = password_reminder.password
          u.salt = password_reminder.salt
          u.save
          password_reminder.voided = 1
          password_reminder.save
          return u
        end
      end

      if u.authenticated?(password)
        u.password_reminders.each do |p|
          p.voided = 1
          p.save
        end
      end
    end

    u && u.authenticated?(password) ? u : nil
  end

  def authenticated?(plain)
    User.encrypt(plain, salt) == password
  end

  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest(password + salt)
  end

  def set_password
    self.salt = User.random_string(10) if !self.salt?
    self.password = User.encrypt(self.password, self.salt)
  end

  def self.random_string(len)
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    newpass = ''
    1.upto(len) {|i| newpass << chars[rand(chars.size - 1)]}
    return newpass
  end

  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest(password + salt)
  end

  def reset_password
    new_password = ''
    ActiveRecord::Base.transaction do
      self.password_reminders.each do |password_reminder|
        password_reminder.voided = 1
        password_reminder.save
      end

      new_password = User.random_string(6)
      password_reminder = PasswordReminder.new
      password_reminder.user_id = self.user_id
      password_reminder.salt = self.salt
      password_reminder.password = User.encrypt(new_password, self.salt)
      password_reminder.save
    end

    return new_password
  end

  def self.new_user(params)
    salt = self.random_string(10)
    user = User.new
    user.password = self.encrypt(params[:password], salt)
    user.salt = salt
    user.person_id = params[:person_id]
    user.username = params[:username]
    return user
  end

  def self.update_user(user, params)
    user.username = params[:user][:username]
    user.secret_question = params[:user][:secret_question]
    user.secret_answer = params[:user][:secret_answer]
    return user
  end

  def void_user(params)
    user = self
    user.voided = 1
    user.voided_by = params[:voided_by]
    user.date_voided = Date.today
    return user
  end

  def self.roles
    roles = ["Auditor", "Custodian", "Data Administrator", "Service Manager",
             "System Administrator", "Viewer"]
    return roles
  end

  def self.gender_options
    g = %w[Male Female]
    return g
  end

  def role
    user_role = self.user_roles.last
    user_role = user_role.role unless user_role.blank?
    return user_role
  end

  def self.per_page
    per_page = 10
    return per_page
  end

  def person_details
    person = self.person
    first_name = person.first_name rescue ""
    last_name = person.last_name rescue ""
    person_names = "#{first_name} #{last_name}"
    person_names
  end

  def self.max_file_size_quota_mb
    max_Size = 50
    max_Size
  end

  def admin_quota_validation
    active_system_plan = SystemPlan.where('active =?', 1).last
    admin_quota = active_system_plan.admin_quota
    admin_count = Person.where(["role =?", "System Administrator"]).all

    if admin_count > admin_quota
      self.person.delete
      errors.add(:base, "Your plan allows for up to #{admin_quota} Administrators.")
    end
  end

end