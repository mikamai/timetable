
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

  before_destroy :validate_references

  def self.policy_class
    Organized::RolePolicy
  end

  def destroyable?
    users.empty?
  end

  private

  def validate_references
    return if destroyable?
    errors.add :base, 'is referenced by users'
    throw :abort
  end
end
