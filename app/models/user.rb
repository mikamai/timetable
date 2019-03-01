# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  openid_uid             :uuid
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :uuid
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_openid_uid            (openid_uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (invited_by_id => users.id)
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:keycloak]

  has_many :organization_memberships, class_name: 'OrganizationMember', inverse_of: :user
  has_many :organizations, through: :organization_memberships
  has_many :project_memberships, class_name: 'ProjectMember', inverse_of: :user
  has_many :projects, through: :project_memberships
  has_many :time_entries, inverse_of: :user
  has_many :time_off_entries, inverse_of: :user
  has_many :time_off_periods, inverse_of: :user
  has_many :this_week_time_entries, class_name: 'Views::ThisWeekTimeEntry'
  has_many :report_entries_exports, inverse_of: :user
  has_and_belongs_to_many :roles, inverse_of: :users

  scope :by_name, -> { order :first_name, :last_name }
  scope :confirmed, -> { where.not confirmed_at: nil }

  validates :first_name,
            :last_name,
            presence: true

  def self.without_enough_entries_this_week
    users = left_joins(:projects, :this_week_time_entries)
    users
      .group('users.id')
      .having('COUNT(projects.id) > 0')
      .having('COALESCE(SUM(this_week_time_entries.amount), 0) < 2400')
  end

  def name
    "#{first_name} #{last_name}"
  end

  def external_provider?
    openid_uid.present?
  end

  def projects_in_organization organization
    projects.in_organization(organization)
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
    membership      = organization_memberships.find_by(organization_id: organization_id)
    membership&.admin?
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create { |user|
      user.email      = auth.info.email
      user.password   = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name  = auth.info.last_name
      user.openid_uid = auth.uid
      user.skip_confirmation!
    }.tap do |user|
      user.update_attributes(
        email:      auth.info.email,
        first_name: auth.info.first_name,
        last_name:  auth.info.last_name,
        openid_uid: auth.uid,
      )
    end
  end
end
