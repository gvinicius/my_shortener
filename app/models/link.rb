# frozen_string_literal: true

class Link < ApplicationRecord
  ALPHANUMERIC_LENGTH = 6
  NUMBER_LENGTH = 1

  validates :original, :shortned, url: { allow_nil: false }
  validates :shortned, uniqueness: true
  # The following validation allows that preset values can be populated from a seeds file.
  before_validation :generate_shortned, unless: lambda {
                                                  id.present? || (shortned.present? && !self.class.exists?(shortned: shortned))
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

  scope :ordered_by_date, -> { order(created_at: :desc) }

  private

  def generate_shortned
    self.shortned = self.class.prepare_url(SecureRandom.alphanumeric(ALPHANUMERIC_LENGTH) +
                    SecureRandom.random_number(NUMBER_LENGTH).to_s)
  end
end
