# frozen_string_literal: true

class CreateThisWeekTimeEntries < ActiveRecord::Migration[5.1]
  def change
    create_view :this_week_time_entries
  end
end
