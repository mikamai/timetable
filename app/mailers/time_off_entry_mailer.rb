# frozen_string_literal: true

class TimeOffEntryMailer < ApplicationMailer
  add_template_helper TimeEntriesHelper

  def request_time_off request
    @request = request
    mail to: 'HR@mikamai.com', subject: "[Timetable] New #{@request.friendly_typology} request from #{@request.user.name}"
  end
end
