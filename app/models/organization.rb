# frozen_string_literal: true

class Organization < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  validates :name,
            presence: true,
            uniqueness: true
end
