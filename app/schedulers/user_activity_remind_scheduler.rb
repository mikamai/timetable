# frozen_string_literal: true

class UserActivityRemindScheduler
  include Sidekiq::Worker

  def perform
    User.without_enough_entries_this_week.find_each do |user|
      UserMailer.not_enough_entries_this_week(user).deliver_later
    end
  end
end
