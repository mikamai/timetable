# frozen_string_literal: true

namespace :users do
  task :make_admin, [:email] => [:environment] do |_t, args|
    user = User.find_by! email: args[:email]
    user.update_attributes! admin: true
    puts 'User is now admin'
  end
end
