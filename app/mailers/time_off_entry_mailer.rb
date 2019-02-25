# frozen_string_literal: true

class TimeOffEntryMailer < ApplicationMailer
  add_template_helper TimeEntriesHelper

  def request_time_off organization, request
    @request = request
    @organization = organization
    mail to: 'HR@mikamai.com', subject: "[Timetable] New #{@request.friendly_typology} request from #{@request.user.name}"
  end

  def confirm_to_user organization, request
    @request = request
    @organization = organization
    mail to: @request.user.email, subject: "[Timetable] Your #{@request.friendly_typology} request has been #{@request.status}"
  end
end
