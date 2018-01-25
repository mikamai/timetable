# frozen_string_literal: true

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
