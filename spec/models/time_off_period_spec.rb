require 'rails_helper'

RSpec.describe TimeOffPeriod, type: :model do
  describe 'validations' do
    it 'require a typology' do
      expect(subject).to have(2).error_on :typology
      subject.typology = 'asd'
      expect(subject).to have(1).errors_on :typology
      subject.typology = 'vacation'
      expect(subject).to have(0).errors_on :typology
    end
  end
end
