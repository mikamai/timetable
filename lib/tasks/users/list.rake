# frozen_string_literal: true

namespace :users do
  task list: :environment do
    puts "|#{'id'.center 38}|#{'email'.center 20}|"
    puts '-' * 61
    User.order(:email).find_each do |user|
      puts "| #{user.id.ljust 37}| #{user.email.ljust 19}|"
    end
    puts '-' * 61
  end
end
