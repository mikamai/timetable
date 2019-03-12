# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id              :uuid             not null, primary key
#  name            :string           not null
#  slug            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#


FactoryBot.define do
  sequence(:task_name) { |n| "Task #{n}" }

  factory :task do
    transient do
      projects []
    end

    organization
    name { generate :task_name }

    after :create do |task, e|
      e.projects.each { |p| task.projects << p }
    end
  end
end
