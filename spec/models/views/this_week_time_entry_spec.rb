# frozen_string_literal: true

# == Schema Information
#
# Table name: this_week_time_entries
#
#  id          :uuid
#  amount      :integer
#  executed_on :date
#  notes       :string
#  created_at  :datetime
#  updated_at  :datetime
#  project_id  :uuid
#  task_id     :uuid
#  user_id     :uuid
#


require 'rails_helper'

RSpec.describe Views::ThisWeekTimeEntry, type: :model do
  subject { described_class }

  it 'returns all entries created during this week' do
    create :time_entry, executed_on: Date.today.beginning_of_week
    create :time_entry, executed_on: Date.today.end_of_week
    expect(subject.count).to eq 2
  end

  it 'ignores entries created before this week' do
    create :time_entry, executed_on: Date.today.beginning_of_week - 1.day
    expect(subject.count).to be_zero
  end

  it 'ignores entries created after this week' do
    create :time_entry, executed_on: Date.today.end_of_week + 1.day
    expect(subject.count).to be_zero
  end
end
