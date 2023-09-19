class NotificationMailer < ApplicationMailer

  settings = YAML.load_file(Rails.root.to_s + '/config/settings.yml')['settings']
  default from: "Easy Asset Manager <#{settings['email']}>"

  def reset_password(person, new_password)
    @name = person.first_name
    @new_password = new_password
    mail(
        to: person.email,
        subject: 'PASSWORD RESET'
    )
  end


end
