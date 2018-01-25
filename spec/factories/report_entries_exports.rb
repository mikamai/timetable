FactoryBot.define do
  factory :report_entries_export do
    organization
    user { create :user, :organized, organization: organization }
  end
end
