# frozen_string_literal: true

class TimeOffEntryMailer < ApplicationMailer
  add_template_helper TimeEntriesHelper

  def request_time_off organization, request
    @request = request
    @organization = organization
    mail to: 'HR@mikamai.com', subject: "[Timetable] New #{@request.friendly_typology} request from #{@request.user.name}"
  end
end
