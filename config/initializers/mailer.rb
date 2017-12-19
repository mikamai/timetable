# frozen_string_literal: true

Rails.application.configure do
  config.action_mailer.default_url_options = { host: Rails.application.secrets.web_domain }

  return if ENV['SENDGRID_USERNAME'].nil? || ENV['SENDGRID_PASSWORD'].nil?
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name:            ENV['SENDGRID_USERNAME'],
    password:             ENV['SENDGRID_PASSWORD'],
    address:              'smtp.sendgrid.net',
    port:                 587,
    authentication:       :plain,
    enable_starttls_auto: true
  }
end
