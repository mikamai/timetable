# frozen_string_literal: true

namespace :orgs do
  desc 'Create an organization'
  task :create, [:name] => [:environment] do |_t, args|
    org = Organization.create! name: args[:name]
    puts "Created organization '#{org.to_param}' with id '#{org.id}'"
  end
end
