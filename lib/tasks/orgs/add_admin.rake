# frozen_string_literal: true

namespace :orgs do
  task :add_admin, %i[org email] => :environment do |_t, args|
    org = Organization.friendly.find args[:org]
    user = User.find_by! email: args[:email]
    OrganizationMembership.create! organization: org, user: user, admin: true
    puts "Admin added"
  end
end
