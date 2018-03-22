# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it 'require an organization' do
      expect(subject).to have(1).error_on :organization
      subject.organization = build :organization
      expect(subject).to have(0).errors_on :organization
    end

    it 'require a client' do
      expect(subject).to have(1).error_on :client
      subject.client = build :client
      expect(subject).to have(0).errors_on :client
    end

    it 'require a name' do
      expect(subject).to have(1).error_on :name
      subject.name = 'asd'
      expect(subject).to have(0).errors_on :name
    end

    it 'require a unique name against the belonging client' do
      existing = create :project
      subject.client = existing.client
      subject.name = existing.name
      expect(subject).to have(1).error_on :name
      subject.name = 'asd'
      expect(subject).to have(0).errors_on :name
    end

    it 'require the client to be in the same organization of the project' do
      subject.organization = create :organization
      subject.client = create :client
      expect(subject).to have(1).error_on :client
    end

    it 'pass when all constraints are met' do
      subject.organization = create :organization
      subject.client = create :client, organization: subject.organization
      subject.name = 'asd'
      expect(subject).to be_valid
    end

    it 'does not require organization integrity on update' do
      subject = create :project
      subject.client = create :client
      expect(subject).to be_valid
    end
  end

  describe 'slug' do
    it 'is composed by client name and project name' do
      client = create :client, name: 'Foo Bar'
      subject = Project.new client: client, organization: client.organization, name: 'Baz'
      expect { subject.save }.to change(subject, :slug).to 'foo-bar-baz'
    end

    it 'is regenerated when name changes' do
      client = create :client, name: 'foo'
      subject = create :project, organization: client.organization, client: client
      expect { subject.update_attributes! name: 'asd' }.to change(subject, :slug).to 'foo-asd'
    end

    it 'is regenerated when client changes' do
      subject = create :project, name: 'asd'
      subject.client = create :client, organization: subject.organization, name: 'foo'
      expect { subject.save! }.to change(subject, :slug).to 'foo-asd'
    end
  end

  describe '#time_budget' do
    it 'returns the previously set value' do
      subject.instance_variable_set '@time_budget', 'asd'
      expect(subject.time_budget).to eq 'asd'
    end

    it 'returns nil if there is no amount' do
      expect(subject.time_budget).to be_nil
    end

    it 'returns the amount formatted as hours:minutes' do
      subject.budget = 0
      expect(subject.time_budget).to eq '0:00'
      subject.budget = 95
      expect(subject.time_budget).to eq '1:35'
    end
  end

  describe '#time_budget=' do
    it 'stores the value in memory' do
      subject.time_budget = 'asd'
      expect(subject.instance_variable_get('@time_budget')).to eq 'asd'
    end

    it 'sets the value as the amount in minutes' do
      subject.time_budget = '1:35'
      expect(subject.budget).to eq 95
    end

    it 'accepts the value as the number of hours' do
      subject.time_budget = 1
      expect(subject.budget).to eq 60
    end

    it 'accepts the value as a float' do
      subject.time_budget = 1.2
      expect(subject.budget).to eq 72
    end

    it 'accepts the value as a float string' do
      subject.time_budget = '1,2'
      expect(subject.budget).to eq 72
    end

    it 'sends to the underlying attribute anything else' do
      expect(subject).to receive(:assign_attributes).with(budget: 'asd')
      subject.time_budget = 'asd'
    end
  end
end
