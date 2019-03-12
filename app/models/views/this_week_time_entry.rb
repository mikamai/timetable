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


module Views
  class ThisWeekTimeEntry < ApplicationRecord
    def readonly?
      true
    end
  end
end
