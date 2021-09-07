# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    original { 'https://test.test' }
    shortned { 'https://test.te' }
  end
end
