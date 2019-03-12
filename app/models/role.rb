# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
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
#  index_roles_on_organization_id_and_slug  (organization_id,slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#



class Role < ApplicationRecord
  extend FriendlyId

  belongs_to :organization, inverse_of: :roles
  has_and_belongs_to_many :users, inverse_of: :roles

  friendly_id :name, use: :scoped, scope: :organization

  scope :by_name, -> { order :name }
  scope :in_organization, ->(organization) { where organization_id: organization.id }

  validates :name,
            presence: true,
            uniqueness: { scope: :organization_id }

  before_destroy :ensure_no_references

  def self.policy_class
    Organized::RolePolicy
  end

  def destroyable?
    users.empty?
  end

  private

  def ensure_no_references
    return if destroyable?
    errors.add :base, 'is referenced by users'
    throw :abort
  end
end
