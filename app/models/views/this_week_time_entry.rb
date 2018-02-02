# frozen_string_literal: true

module Views
  class ThisWeekTimeEntry < ApplicationRecord
    def readonly?
      true
    end
  end
end
