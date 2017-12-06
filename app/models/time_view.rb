# frozen_string_literal: true

class TimeView
  include ActiveModel::Model

  ID_FORMAT = '%Y-%m-%d'

  class << self
    def today organization
      new date: Date.today, organization: organization
    end

    def find id, organization
      new date: Date.strptime(id, ID_FORMAT), organization: organization
    end

    def find_week_including id, organization
      date = Date.strptime id, ID_FORMAT
      (date.beginning_of_week..date.end_of_week).map do |d|
        new date: d, organization: organization
      end
    end
  end

  attr_accessor :date, :organization

  delegate :id, to: :organization, prefix: true

  def time_entries
    TimeEntry.in_time_view(self)
  end

  def id
    date.strftime ID_FORMAT
  end

  def == other
    self.class == other.class && id == other.id
  end

  def persisted?
    true
  end

  def to_param
    id
  end
end
