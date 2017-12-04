# frozen_string_literal: true

namespace :users do
  task list: :environment do
    puts "|#{'id'.center 38}|#{'email'.center 20}|#{'admin'.center 7}|"
    puts '-' * 69
    User.order(:email).find_each do |user|
      puts "| #{user.id.ljust 37}| #{user.email.ljust 19}| #{user.admin.to_s.ljust 5} |"
    end
    puts '-' * 69
  end
end
