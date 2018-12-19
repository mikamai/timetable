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
