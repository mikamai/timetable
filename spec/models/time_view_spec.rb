# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeView do
  let(:org) { create :organization }
  let(:user) { create :user, :organized, organization: org }

  subject { TimeView.new date: Date.new(2017, 2, 1), organization: org, user: user }

  describe '::today' do
    it 'returns a TimeView for the current date' do
      instance = described_class.today org, user
      expect(instance).to be_a described_class
      expect(instance.date).to eq Date.today
    end
  end

  describe '::find' do
    it 'returns a TimeView for the given date id' do
      instance = described_class.find '2017-02-01', org, user
      expect(instance).to be_a described_class
      expect(instance.date).to eq Date.new(2017, 2, 1)
    end
  end

  describe '#id' do
    it 'returns a representation of the current date' do
      expect { subject.date = Date.new 2017, 3, 1 }.to change(subject, :id).from('2017-02-01').to('2017-03-01')
    end
  end

  describe '#time_entries' do
    it 'excludes entries executed in other organizations' do
      organization = create(:organization_member, user: subject.user).organization
      create :time_entry, executed_on: subject.date, user: subject.user, organization: organization
      expect(subject.time_entries).to be_empty
    end

    it 'excludes entries executed by other users' do
      other_user = create :user, :organized, organization: org
      create :time_entry, executed_on: subject.date, user: other_user, organization: org
      expect(subject.time_entries).to be_empty
    end

    it 'excludes entries executed in different dates' do
      create :time_entry, executed_on: subject.date + 1.day, user: subject.user,
             organization: subject.organization
      expect(subject.time_entries).to be_empty
    end

    it 'returns entries executed by the same user, in the same date, in the same organization' do
      te = create :time_entry, executed_on: subject.date, user: subject.user,
                  organization: subject.organization
      expect(subject.time_entries).to eq [te]
    end
  end

  describe 'equality' do
    it 'does not match if class differs' do
      mocked = double(id: subject.id)
      expect(subject).not_to eq mocked
    end

    it 'does not match if #id differs' do
      other = subject.dup.tap { |t| t.date += 1.day }
      expect(subject).not_to eq other
    end

    it 'does not match if #organization differs' do
      other = subject.dup.tap { |t| t.organization = create :organization }
      expect(subject).not_to eq other
    end

    it 'does not match if #user differs' do
      other = subject.dup.tap { |t| t.user = create :user, :organized, organization: org }
      expect(subject).not_to eq other
    end

    it 'matches when all attributes match' do
      expect(subject).to eq subject.dup
    end
  end
end
