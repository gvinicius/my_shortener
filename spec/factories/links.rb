FactoryBot.define do
  factory :link do
    original { 'https://test.test' }
    shortned { 'https://test.te' }
  end
end
