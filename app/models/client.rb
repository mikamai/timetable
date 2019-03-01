# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id              :uuid             not null, primary key
#  name            :string           not null
#  slug            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#
# Indexes
#
#  index_clients_on_organization_id_and_name  (organization_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#


class Client < ApplicationRecord
  extend FriendlyId

  belongs_to :organization, inverse_of: :clients
  has_many :projects, inverse_of: :client

  friendly_id :name, use: :scoped, scope: :organization

  scope :by_name, -> { order :name }
  scope :in_organization, ->(organization) { where organization_id: organization.id }

  validates :name,
            presence: true,
            uniqueness: { scope: :organization_id }

  before_destroy :ensure_no_references

  delegate :name, to: :organization, prefix: true

  def self.policy_class
    Organized::ClientPolicy
  end

  def destroyable?
    projects.with_deleted.empty?
  end

  private

  def ensure_no_references
    return if destroyable?
    errors.add :base, 'is referenced by projects'
    throw :abort
  end

  def should_generate_new_friendly_id?
    super || (persisted? && name_changed?)
  end
end
