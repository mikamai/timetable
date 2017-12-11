# frozen_string_literal: true

module Reports
  class StaffReport < BaseReport
    Row = Struct.new(:user, :amount)
    class Row
      delegate :name, to: :user
    end

    def rows
      amount_by_user = time_entries.group(:user_id).sum(:amount)
      users = User.where(id: amount_by_user.keys)
      amount_by_user.map do |k, v|
        Row.new(users.detect { |p| p.id == k }, v)
      end
    end
  end
end
