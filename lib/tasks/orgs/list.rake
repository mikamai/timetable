# frozen_string_literal: true

namespace :orgs do
  task list: :environment do
    puts "|#{'id'.center 38}|#{'slug'.center 20}|#{'name'.center 20}|"
    puts '-' * 82
    Organization.order(:name).find_each do |org|
      puts "| #{org.id.ljust 37}| #{org.to_param.ljust 19}| #{org.name.ljust 19}|"
    end
    puts '-' * 82
  end
end
