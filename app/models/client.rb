# frozen_string_literal: true

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
    projects.empty?
  end

  private

  def ensure_no_references
    return if destroyable?
    errors.add :base, 'is referenced by projects'
    throw :abort
  end
end
