require 'uri'
require 'securerandom'

class Url < ActiveRecord::Base
  before_create :generate_url_key

  validates :full_url,
            presence: true,
            format: { with: URI.regexp(%w(http https)),
                      message: "The 'url' parameter is invalid!" }

  def short_url
    "#{ENV['HOST_NAME']}/#{url_key}"
  end

  protected

  def generate_url_key
    generated_key = SecureRandom.hex[0..3]
    if Url.exists?(url_key: generated_key)
      generate_url_key
    else
      self.url_key = generated_key if url_key.nil?
    end
  end
end
