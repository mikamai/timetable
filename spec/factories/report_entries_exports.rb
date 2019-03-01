# == Schema Information
#
# Table name: report_entries_exports
#
#  id              :uuid             not null, primary key
#  completed_at    :datetime
#  export_query    :json
#  file            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :report_entries_export do
    organization
    user { create :user, :organized, organization: organization }
  end
end
