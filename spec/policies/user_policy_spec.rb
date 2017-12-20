# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy do
  let(:user) { create :user, admin: false }
  subject { described_class }

  permissions :index?, :create? do
    it 'denies access if user is not admin' do
      expect(subject).not_to permit(user, User)
    end

    it 'grants access to global admins' do
      user.update_column :admin, true
      expect(subject).to permit(user, User)
    end
  end
end
