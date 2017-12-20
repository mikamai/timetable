# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :organization_memberships, class_name: 'OrganizationMember', inverse_of: :user
  has_many :organizations, through: :organization_memberships
  has_many :project_memberships, class_name: 'ProjectMember', inverse_of: :user
  has_many :projects, through: :project_memberships
  has_many :time_entries, inverse_of: :user
  has_and_belongs_to_many :roles, inverse_of: :users

  scope :by_name, -> { order :first_name, :last_name }
  scope :confirmed, -> { where.not confirmed_at: nil }

  validates :first_name,
            :last_name,
            presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def organizations?
    organizations.any?
  end

  def membership_in organization_or_project
    if organization_or_project.is_a? Organization
      organization_memberships.find_by organization_id: organization_or_project.id
    elsif organization_or_project.is_a? Project
      project_memberships.find_by project_id: organization_or_project.id
    else
      raise NotImplementedError, 'Only organizations or projects are allowed. ' \
                                 "Argument is of type #{organization_or_project.class.name}."
    end
  end

  def admin_in_organization? organization_or_id
    organization_id = organization_or_id.respond_to?(:id) ? organization_or_id.id : organization_or_id
    membership = organization_memberships.find_by(organization_id: organization_id)
    membership&.admin?
  end
end
