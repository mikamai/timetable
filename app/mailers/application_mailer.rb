# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: proc { Rails.application.secrets.mail_from }
  layout 'mailer'
end
