require 'rails_helper'

describe Request do
  let(:successful_response) {
    [[{"charges_total"=>0,
     "created_at"=>"2017-05-01T03:22:31Z",
     "credits_total"=>0,
     "id"=>"f430c888-a2ec-4870-8ed1-c20541da7826",
     "number"=>11666125,
     "period_end"=>"2017-06-01",
     "period_start"=>"2017-05-01",
     "state"=>1,
     "total"=>7795,
     "updated_at"=>"2017-06-12T22:43:57Z"},
    {"charges_total"=>0,
     "created_at"=>"2016-01-01T01:26:13Z",
     "credits_total"=>0,
     "id"=>"f7949773-3625-479a-9896-d65a50d7d564",
     "number"=>6774154,
     "period_end"=>"2016-02-01",
     "period_start"=>"2016-01-01",
     "state"=>1,
     "total"=>7310,
     "updated_at"=>"2016-02-11T00:14:29Z"},
    {"charges_total"=>0,
     "created_at"=>"2014-01-01T01:49:03Z",
     "credits_total"=>0,
     "id"=>"ff6532e5-c6a3-4f85-aa9c-fcdf4b434df2",
     "number"=>2439589,
     "period_end"=>"2014-02-01",
     "period_start"=>"2014-01-01",
     "state"=>1,
     "total"=>9732,
     "updated_at"=>"2014-02-07T15:21:42Z"}],
   200]
  }

  let(:unsuccessful_response) {
    [{"id"=>"not_found",
      "message"=>"The requested API endpoint was not found. Are you using the right HTTP verb (i.e. `GET` vs. `POST`), and did you specify your intended version with the `Accept` header?"},
   404]
  }

  describe '.where' do
    before do
      allow(Request).to receive(:where).with('/chimichangas', false).and_return(successful_response)
    end

    it 'returns array' do
      expect(Request.where('/chimichangas', false)).to be_an_instance_of(Array)
    end

    context 'when response is successful' do
      it 'returns success code' do
        expect(Request.where('/chimichangas', false)[1]).to eq(200)
      end

      it 'returns JSON objects' do
        expect(Request.where('/chimichangas', false)[0].count).to eq(3)
      end
    end

    context 'when response is not successful' do
      before do
        allow(Request).to receive(:where).with('/unreal-expectations', false).and_return(unsuccessful_response)
      end

      it 'returns unsuccessful code' do
        expect(Request.where('/unreal-expectations', false)[1]).to eq(404)
      end

      it 'returns error message' do
        expect(Request.where('/unreal-expectations', false)[0]['message']).to eq('The requested API endpoint was not found. Are you using the right HTTP verb (i.e. `GET` vs. `POST`), and did you specify your intended version with the `Accept` header?')
      end
    end
  end
end
