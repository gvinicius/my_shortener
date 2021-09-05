class Link < ApplicationRecord

  ALPHANUMERIC_LENGTH = 6
  NUMBER_LENGTH = 1
  validates :original, :shortned, url: { allow_nil: false }
  validates :shortned, uniqueness: true
  before_validation :generate_shortned, unless: -> { id.present? || (shortned.present? && !self.class.exists?(shortned: shortned)) }

  private
  def generate_shortned
    port = Rails.application.routes.default_url_options[:port]
    self.shortned = Rails.application.routes.default_url_options[:host] +
      (port.present? ? ':' + port : '') +
      + '/' + SecureRandom.alphanumeric(ALPHANUMERIC_LENGTH) +
      SecureRandom.random_number(NUMBER_LENGTH).to_s
  end
end


