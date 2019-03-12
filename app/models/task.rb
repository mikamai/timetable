# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id              :uuid             not null, primary key
#  name            :string           not null
#  slug            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#


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
