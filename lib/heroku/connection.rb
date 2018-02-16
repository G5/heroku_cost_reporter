require 'faraday'
require 'json'

class Connection
  BASE = "#{ENV['HEROKU_BASE_URL']}"

  def self.api
    Faraday.new(url: BASE) do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.headers['Authorization'] = "Bearer #{ENV['HEROKU_AUTH_TOKEN']}"
      faraday.headers['Accept'] = "application/vnd.heroku+json; version=3"
      faraday.headers['Accept-encoding'] = 'gzip;q=0,deflate,sdch'
    end
  end
end

