# frozen_string_literal: true

class UserMailer < ApplicationMailer
  add_template_helper TimeEntriesHelper

  def not_enough_entries_this_week user
    @user = user
    @amount_this_week = @user.this_week_time_entries.sum(:amount)
    mail to: @user.email, subject: 'Remember to track your time this week'
  end
end
