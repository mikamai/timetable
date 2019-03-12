# frozen_string_literal: true

# == Schema Information
#
# Table name: time_entries
#
#  id          :uuid             not null, primary key
#  amount      :integer          not null
#  executed_on :date             not null
#  notes       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :uuid             not null
#  task_id     :uuid             not null
#  user_id     :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (task_id => tasks.id)
#  fk_rails_...  (user_id => users.id)
#


FactoryBot.define do
  factory :time_entry do
    transient do
      organization { create :organization }
    end

    user { create :user, :organized, organization: organization }
    project { create :project, organization: organization, users: [user] }
    task { create :task, organization: organization, projects: [project] }
    executed_on { Date.today }
    amount 1
  end
end
