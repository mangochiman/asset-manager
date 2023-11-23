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

  def checkout_asset(asset_activity)
    @asset = asset_activity.asset
    @person = asset_activity.person
    @assets = @person.assets_with_me
    mail(
        to: @person.email,
        subject: 'CHECKOUT NOTIFICATION'
    )
  end

  def checkout_asset_stock(asset_activity)
    @asset_stock = asset_activity.asset_stock
    @person = asset_activity.person
    @assets = @person.assets_with_me
    mail(
        to: @person.email,
        subject: 'CHECKOUT NOTIFICATION'
    )
  end

end
