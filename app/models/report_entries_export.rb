# frozen_string_literal: true

# == Schema Information
#
# Table name: report_entries_exports
#
#  id              :uuid             not null, primary key
#  completed_at    :datetime
#  export_query    :json
#  file            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#


class ReportEntriesExport < ApplicationRecord
  belongs_to :organization, inverse_of: :report_entries_exports
  belongs_to :user, inverse_of: :report_entries_exports

  mount_uploader :file, ExportUploader

  def self.policy_class
    Organized::ReportEntriesExportPolicy
  end

  def organization_membership
    user.membership_in organization
  end

  def completed?
    completed_at.present?
  end
end
