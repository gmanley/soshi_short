require 'spec_helper'

describe Url do
  before do
    Url.create(url_key: '8802', full_url: 'http://www.amazon.com/')
    Url.create(url_key: '9b0a', full_url: 'http://www.ebay.com/')
    Url.create(url_key: '612c', full_url: 'http://news.ycombinator.com/')
  end

  context 'accessing url key that exists' do

    it 'redirects to correct full url' do
      get '/8802'
      last_response.should be_redirect
      follow_redirect!
      last_request.url.should be_eql('http://www.amazon.com/')
    end
  end
end