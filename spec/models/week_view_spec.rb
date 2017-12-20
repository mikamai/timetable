# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeekView do
  let(:org) { create :organization }
  let(:user) { create :user, :organized, organization: org }

  subject { WeekView.find_by_time_view_id '2017-03-01', org, user }

  describe '::find_by_current_week' do
    it 'returns a WeekView for the current week' do
      instance = described_class.find_by_current_week org, user
      expect(instance).to be_a described_class
      expect(instance.beginning_date).to eq Date.today.beginning_of_week
      expect(instance.end_date).to eq Date.today.end_of_week
    end

    it 'sets a collection of time views for the current week' do
      Timecop.freeze Date.new(2017, 3, 1) do
        instance = described_class.find_by_current_week org, user
        expect(instance.time_views.map(&:date)).to eq (Date.new(2017, 2, 27)..Date.new(2017, 3, 5)).to_a
      end
    end

    it 'sets the #selected_id to today' do
      Timecop.freeze Date.new(2017, 3, 1) do
        expect(described_class.find_by_current_week(org, user).selected_id).to eq '2017-03-01'
      end
    end
  end

  describe '::find_by_time_view_id' do
    it 'returns a WeekView for the week of the given date id' do
      instance = described_class.find_by_time_view_id '2017-03-01', org, user
      expect(instance).to be_a described_class
      expect(instance.beginning_date).to eq Date.new(2017, 2, 27)
      expect(instance.end_date).to eq Date.new(2017, 3, 5)
    end

    it 'sets a collection of time views for the given week' do
      instance = described_class.find_by_time_view_id '2017-03-01', org, user
      expect(instance.time_views.map(&:date)).to eq (Date.new(2017, 2, 27)..Date.new(2017, 3, 5)).to_a
    end

    it 'sets the #selected_id to the given date id' do
      expect(described_class.find_by_time_view_id('2017-03-01', org, user).selected_id).to eq '2017-03-01'
    end
  end

  describe '#selected_time_view' do
    it 'returns the TimeView of the given selected id' do
      instance = described_class.find_by_time_view_id '2017-03-01', org, user
      expect(instance.selected_time_view).to eq TimeView.find('2017-03-01', org, user)
    end
  end

  describe '#total_amount' do
    it 'returns 0 when there are no entries in the week' do
      expect(subject.total_amount).to be_zero
    end

    it 'excludes time entries executed outside of the week' do
      create :time_entry, executed_on: Date.new(2017, 2, 26), organization: subject.organization,
             user: subject.user
      create :time_entry, executed_on: Date.new(2017, 3, 6), organization: subject.organization,
      user: subject.user
      expect(subject.total_amount).to be_zero
    end

    it 'excludes time entries executed by other users' do
      other_user = create :user, :organized, organization: org
      create :time_entry, executed_on: Date.new(2017, 3, 1), organization: subject.organization,
             user: other_user
      expect(subject.total_amount).to be_zero
    end

    it 'excludes time entries executed in other organizations' do
      other_org = create(:organization_member, user: subject.user).organization
      create :time_entry, executed_on: Date.new(2017, 3, 1), organization: other_org,
             user: subject.user
    end

    it 'returns the total amount of minutes spent in the selected week' do
      create :time_entry, executed_on: Date.new(2017, 2, 27), amount: 1,
             organization: subject.organization, user: subject.user
      create :time_entry, executed_on: Date.new(2017, 3, 5), amount: 2,
             organization: subject.organization, user: subject.user
      expect(subject.total_amount).to eq 3
    end
  end
end
