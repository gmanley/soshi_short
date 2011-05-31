require 'uri'
require 'digest/md5'

module SoshiShort
  class InvalidUrl < StandardError; end
  class Url
    include Mongoid::Document

    field :url_key, :type => String
    field :full_url, :type => String
    field :last_accessed, :type => Time
    field :times_viewed, :type => Integer, :default => 0

    after_initialize :generate_url_key

    validates_format_of :full_url, :with => URI::regexp(%w(http https)), :message => "The 'url' parameter is invalid!"
    validates_presence_of [:full_url, :url_key]

    def short_url
      App.settings.config['hostname'] + "/#{self.url_key}"
    end

    protected
    def generate_url_key
      generated_key = Digest::MD5.hexdigest(full_url)[0..3]
      !Url.where(:url_key => generated_key).empty? ? generate_url_key : self.url_key = generated_key if url_key.nil?
    end
  end
end