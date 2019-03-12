# == Schema Information
#
# Table name: time_off_entries
#
#  id                 :uuid             not null, primary key
#  amount             :integer          not null
#  executed_on        :date             not null
#  notes              :string
#  status             :string           default("pending")
#  typology           :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  organization_id    :uuid             not null
#  time_off_period_id :uuid
#  user_id            :uuid             not null
#

FactoryBot.define do
  factory :time_off_entry do
    transient do
      organization { create :organization }
    end

    user { create :user, :organized, organization: organization }
    executed_on { Date.today }
    amount 1
    typology 'paid'
    notes 'asd'
  end
end
