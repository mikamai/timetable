# frozen_string_literal: true

class BadJsonProvidedError < StandardError
  def initialize e
    super "Cannot parse JSON because of: #{e.message}"
  end
end
