# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email                  { 'user@example.com' }
    password               { 'password' }
    username               { Faker::Name.name }
  end
end
