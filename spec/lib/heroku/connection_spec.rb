require 'rails_helper'

describe Connection do
  describe ".api" do
    let(:connection) { Connection.api }
    let(:token) { "zvakuwana" }

    before do
      stub_const("Connection::BASE", "http://www.kuvarira-mukati")
      stub_const('ENV', {'HEROKU_AUTH_TOKEN' => token})
      expect(Connection::BASE).to eq("http://www.kuvarira-mukati")
    end

    it "establishes a new Faraday connection" do 
      expect(connection.headers['Authorization']).to eq("Bearer #{token}")
      expect(connection.headers['Accept']).to eq("application/vnd.heroku+json; version=3")
      expect(connection.headers['Accept-encoding']).to eq("gzip;q=0,deflate,sdch")
    end
  end
end
