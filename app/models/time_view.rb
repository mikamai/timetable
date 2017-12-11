# frozen_string_literal: true

class TimeView
  include ActiveModel::Model

  ID_FORMAT = '%Y-%m-%d'

  class << self
    def today organization, user
      new date: Date.today, organization: organization, user: user
    end

    def find id, organization, user
      new date: Date.strptime(id, ID_FORMAT), organization: organization, user: user
    end
  end

  attr_accessor :date, :organization, :user

  delegate :id, to: :organization, prefix: true

  def time_entries
    TimeEntry.in_organization(organization)
             .executed_on(date)
             .executed_by(user)
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
