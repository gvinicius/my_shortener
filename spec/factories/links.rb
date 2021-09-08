# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    original { 'https://test.test' }
    shortened { 'https://test.te' }
  end
end
