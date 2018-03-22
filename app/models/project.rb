# frozen_string_literal: true

class Project < ApplicationRecord
  extend FriendlyId
  include HoursAmount

  add_hours_amount_to :budget

  belongs_to :organization, inverse_of: :projects
  belongs_to :client, inverse_of: :projects
  has_many :members, class_name: 'ProjectMember', inverse_of: :project
  has_many :users, through: :members
  has_many :time_entries, inverse_of: :project
  has_and_belongs_to_many :tasks, inverse_of: :projects

  accepts_nested_attributes_for :members, reject_if: :all_blank, allow_destroy: true
  friendly_id :slug_candidates, use: %i[slugged scoped], scope: :organization

  scope :by_name, -> { includes(:client).order 'clients.name', 'projects.name' }
  scope :in_organization, ->(organization) { where organization_id: organization.id }

  validates :name,
            presence: true,
            uniqueness: { scope: %i[client_id] }
  validate :validate_organization_references, on: :create

  delegate :name, to: :client, prefix: true, allow_nil: true

  def self.policy_class
    Organized::ProjectPolicy
  end

  def as_json opts = {}
    super opts.reverse_merge(
      only: %i[id organization_id name],
      include: { tasks: { only: %i[id name] } }
    )
  end

  def budget?
    budget.present?
  end

  def remaining_budget
    return nil unless budget?
    budget - total_amount
  end

  def full_name
    "#{client_name} / #{name}"
  end

  def slug_candidates
    [
      %i[client_name name]
    ]
  end

  def total_amount
    time_entries.sum(:amount)
  end

  private

  def validate_organization_references
    return if client.nil? || organization.nil? || client.organization == organization
    errors.add :client, :forbidden
  end

  def should_generate_new_friendly_id?
    key_fields_changed = name_changed? || client_id_changed?
    super || (persisted? && key_fields_changed)
  end
end
