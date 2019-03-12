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

require 'rails_helper'

RSpec.describe TimeOffPeriod, type: :model do
  describe 'validations' do
    it 'require a user' do
      expect(subject).to have(1).error_on :user
      subject.user = build :user
      expect(subject).to have(0).errors_on :user
    end

    it 'require a start date' do
      expect(subject).to have(1).error_on :start_date
      subject.start_date = Date.today
      expect(subject).to have(0).errors_on :start_date
    end

    it 'require an end date' do
      expect(subject).to have(1).error_on :end_date
      subject.end_date = Date.today
      expect(subject).to have(0).errors_on :end_date
    end

    it 'require a typology' do
      expect(subject).to have(2).error_on :typology
      subject.typology = 'asd'
      expect(subject).to have(1).errors_on :typology
      subject.typology = 'vacation'
      expect(subject).to have(0).errors_on :typology
    end

    it 'require an organization' do
      expect(subject).to have(1).error_on :organization
      subject.organization = build :organization
      expect(subject).to have(0).errors_on :organization
    end

    it 'cannot have end date before start date' do
      expect(subject).to have(1).error_on :end_date
      subject.start_date = Date.today
      subject.end_date = Date.yesterday
      expect(subject).to have(1).error_on :end_date
      subject.end_date = Date.tomorrow
      expect(subject).to have(0).error_on :end_date
    end
  end
end
