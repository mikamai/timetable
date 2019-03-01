# == Schema Information
#
# Table name: time_off_periods
#
#  id              :uuid             not null, primary key
#  duration        :integer          not null
#  end_date        :date             not null
#  notes           :string
#  start_date      :date             not null
#  status          :string           default("pending")
#  typology        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#

FactoryBot.define do
  factory :time_off_period do
    transient do
      organization { create :organization }
    end

    user { create :user, :organized, organization: organization }
    start_date { Date.today }
    end_date { Date.tomorrow }
    typology 'vacation'
  end
end
