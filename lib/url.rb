require 'uri'
require 'securerandom'

class Url
  include Mongoid::Document

  field :url_key,       type: String
  field :full_url,      type: String
  field :last_accessed, type: Time
  field :times_viewed,  type: Integer, default: 0

  before_create :generate_url_key

  validates :full_url,
            presence: true,
            format: { with: URI.regexp(%w(http https)),
                      message: "The 'url' parameter is invalid!" }

  def short_url
    "#{App.settings.config.hostname}/#{url_key}"
  end

  protected
  def generate_url_key
    generated_key = SecureRandom.hex[0..3]
    if Url.exists?(conditions: { url_key: generated_key })
      generate_url_key
    else
      self.url_key = generated_key if url_key.nil?
    end
  end
end
