# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeOffEntry, type: :model do
  describe 'validations' do
    it 'require a user' do
      expect(subject).to have(1).error_on :user
      subject.user = build :user
      expect(subject).to have(0).errors_on :user
    end

    it 'require an execution date' do
      expect(subject).to have(1).error_on :executed_on
      subject.executed_on = Date.today
      expect(subject).to have(0).errors_on :executed_on
    end

    it 'require an amount' do
      expect(subject).to have(1).error_on :amount
      subject.amount = -10
      expect(subject).to have(1).error_on :amount
      subject.amount = 1
      expect(subject).to have(0).errors_on :amount
    end

    it 'pass when all constraints are met' do
      subject.user = create :user, :organized
      subject.executed_on = Date.today
      subject.amount = 1
      expect(subject).to be_valid
    end

    it 'does not require organization integrity on update' do
      subject = create :time_off_entry
      subject.project = create :project
      expect(subject).to be_valid
    end
  end

  describe '#time_amount' do
    it 'returns the previously set value' do
      subject.instance_variable_set '@time_amount', 'asd'
      expect(subject.time_amount).to eq 'asd'
    end

    it 'returns nil if there is no amount' do
      expect(subject.time_amount).to be_nil
    end

    it 'returns the amount formatted as hours:minutes' do
      subject.amount = 0
      expect(subject.time_amount).to eq '0:00'
      subject.amount = 95
      expect(subject.time_amount).to eq '1:35'
    end
  end

  describe '#time_amount=' do
    it 'stores the value in memory' do
      subject.time_amount = 'asd'
      expect(subject.instance_variable_get('@time_amount')).to eq 'asd'
    end

    it 'sets the value as the amount in minutes' do
      subject.time_amount = '1:35'
      expect(subject.amount).to eq 95
    end

    it 'accepts the value as the number of hours' do
      subject.time_amount = 1
      expect(subject.amount).to eq 60
    end

    it 'accepts the value as a float' do
      subject.time_amount = 1.2
      expect(subject.amount).to eq 72
    end

    it 'accepts the value as a float string' do
      subject.time_amount = '1,2'
      expect(subject.amount).to eq 72
    end

    it 'sends to the underlying attribute anything else' do
      expect(subject).to receive(:assign_attributes).with(amount: 'asd')
      subject.time_amount = 'asd'
    end
  end
end
