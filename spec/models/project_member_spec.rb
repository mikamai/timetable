# frozen_string_literal: true

# == Schema Information
#
# Table name: project_members
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_project_members_on_user_id_and_project_id  (user_id,project_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#


require 'rails_helper'

RSpec.describe ProjectMember, type: :model do
  describe 'validations' do
    it 'require a project' do
      expect(subject).to have(1).error_on :project
      subject.project = build :project
      expect(subject).to have(0).errors_on :project
    end

    it 'require a user' do
      expect(subject).to have(1).error_on :user
      subject.user = build :user
      expect(subject).to have(0).errors_on :user
    end

    it 'require the project to be in the same organization of the user' do
      subject.user = create :user, :organized
      subject.project = create :project
      expect(subject).to have(1).error_on :project
    end

    it 'pass when all constraints are met' do
      subject.user = create :user, :organized
      subject.project = create :project, organization: subject.user.organizations.first
      expect(subject).to be_valid
    end

    it 'does not require organization integrity on update' do
      subject = create :project_member
      subject.user = create :user
      expect(subject).to be_valid
    end
  end
end
