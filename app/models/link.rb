# frozen_string_literal: true

class Link < ApplicationRecord
  ALPHANUMERIC_LENGTH = 6
  NUMBER_LENGTH = 10

  validates :original, :shortened, url: { allow_nil: false }
  validates :shortened, uniqueness: true
  # The following validation allows that preset values can be populated from a seeds file.
  before_validation :generate_shortened, unless: lambda {
                                                   id.present? || (shortened.present? && !self.class.exists?(shortened: shortened))
                                                 }
  belongs_to :user, optional: true

  def increment_access_count
    update(access_count: access_count + 1)
  end

  def username
    user.try(:username)
  end

  def self.prepare_url(suffix)
    port = Rails.application.routes.default_url_options[:port]
    Rails.application.routes.default_url_options[:host] +
      (port.present? ? ":#{port}" : '') +
      + '/' + suffix
  end

  def frequency
    date1 = Time.zone.now
    date2 = self.created_at
    access_count / ((1 + date2.year * 12 + date2.month) - (date1.year * 12 + date1.month))
  end

  scope :ordered_by_date, -> { order(created_at: :desc) }

  private

  def generate_shortened
    self.shortened = self.class.prepare_url(SecureRandom.alphanumeric(ALPHANUMERIC_LENGTH) +
                    SecureRandom.random_number(NUMBER_LENGTH).to_s)
  end
end
