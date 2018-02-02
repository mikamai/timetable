# frozen_string_literal: true

class Task < ApplicationRecord
  extend FriendlyId

  belongs_to :organization, inverse_of: :tasks
  has_and_belongs_to_many :projects, inverse_of: :tasks
  has_many :time_entries, inverse_of: :task

  friendly_id :name, use: :scoped, scope: :organization

  scope :by_name, -> { order :name }

  validates :organization_id,
            presence: true
  validates :name,
            presence: true,
            uniqueness: { scope: :organization_id }

  def self.policy_class
    Organized::TaskPolicy
  end

  private

  def should_generate_new_friendly_id?
    super || (persisted? && name_changed?)
  end
end
