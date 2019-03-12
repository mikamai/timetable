# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id              :uuid             not null, primary key
#  archived_at     :datetime
#  budget          :integer
#  name            :string           not null
#  slug            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  client_id       :uuid             not null
#  organization_id :uuid             not null
#
# Indexes
#
#  index_projects_on_archived_at               (archived_at)
#  index_projects_on_organization_id_and_slug  (organization_id,slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (organization_id => organizations.id)
#


FactoryBot.define do
  sequence(:project_name) { |n| "Project #{n}" }

  factory :project do
    transient do
      users []
    end

    organization
    client { build :client, organization: organization }
    name { generate :project_name }

    after :create do |project, e|
      e.users.each do |u|
        project.members << create(:project_member, project: project, user: u)
      end
    end

    trait :with_tasks do
      transient do
        tasks_count 2
      end

      after :create do |project, e|
        e.tasks_count.times do
          project.tasks << create(:task, organization: project.organization)
        end
      end
    end
  end
end
