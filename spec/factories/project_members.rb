# frozen_string_literal: true

# == Schema Information
#
# Table name: project_members
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_project_members_on_user_id_and_project_id  (user_id,project_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#


FactoryBot.define do
  factory :project_member do
    project
    user { create :user, :organized, organization: project.organization }
  end
end
