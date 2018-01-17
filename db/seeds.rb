# frozen_string_literal: true

# Inspired by errbit db/seeds.rb

require 'securerandom'

puts "Seeding database"
puts "-------------------------------"

# Create an initial Admin User
admin_email    = ENV['TIMETABLE_ADMIN_EMAIL'] || "admin@timetable.mikamai.com"
admin_pass     = ENV['TIMETABLE_ADMIN_PASSWORD'] || SecureRandom.urlsafe_base64(12)[0, 12]

puts "Creating an initial admin user:"
puts "-- email:    #{admin_email}"
puts "-- password: #{admin_pass}"
puts ""
puts "Be sure to note down these credentials now!"

user = User.find_or_initialize_by(email: admin_email)
user.first_name = 'Timetable'
user.last_name = 'Admin'
user.password = admin_pass
user.password_confirmation = admin_pass
user.admin = true
user.save!
