FactoryBot.define do
  factory :time_off_period do
    transient do
      organization { create :organization }
    end

    user { create :user, :organized, organization: organization }
    executed_on { Date.today }
    amount 1
  end
end
