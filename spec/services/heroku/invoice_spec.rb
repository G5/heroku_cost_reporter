require 'spec_helper'

describe Heroku::Invoice do
  let(:response_array) {
        [ {"charges_total"=>0, "created_at"=>"2014-10-01T01:09:53Z", "credits_total"=>0, "id"=>"0231b43f-76d9-40d7-a694-c6b250f89be3", "number"=>3721524, "period_end"=>"2014-11-01", "period_start"=>"2014-10-01", "state"=>1, "total"=>28136, "updated_at"=>"2014-11-11T15:12:00Z"},
          {"charges_total"=>0, "created_at"=>"2016-05-01T04:38:37Z", "credits_total"=>0, "id"=>"0b9fb0b1-c4eb-4abc-8d89-2aabba6b517d", "number"=>7778781, "period_end"=>"2016-06-01", "period_start"=>"2016-05-01", "state"=>1, "total"=>1887, "updated_at"=>"2016-06-13T21:18:27Z"},
          {"charges_total"=>0, "created_at"=>"2017-10-01T03:33:59Z", "credits_total"=>0, "id"=>"1122e8ed-f0d3-4fa6-9bd4-91034c40df94", "number"=>13972100, "period_end"=>"2017-11-01", "period_start"=>"2017-10-01", "state"=>1, "total"=>0, "updated_at"=>"2017-11-01T20:15:46Z"} ]
      }

  let(:resource_path) { "/wild-child/albums" }
  let(:clear_cache) { false }

  describe ".all_invoices" do
    context "when relevant request" do
      it "class receives message with one param" do
        expect(Heroku::Invoice).to receive(:all_invoices).with(clear_cache).and_return(response_array)
        described_class.all_invoices(clear_cache)
      end

      it "creates new invoice object from response" do
        response_array.map do |invoice|
          expect(Heroku::Invoice).to receive(:new).with(invoice)
          Heroku::Invoice.new(invoice)
        end
      end
    end
  end

  describe ".most_current_invoices" do
    let(:invoice1) { Fabricate(:invoice) }
    let(:invoice2) { Fabricate(:invoice, charges_total: 20, period_end: "2018-02-01", period_start: "2018-01-01") }
    let(:invoice3) { Fabricate(:invoice, charges_total: 20, period_end: "2018-03-01", period_start: "2018-02-01") }
    let(:invoices) { [invoice1, invoice2, invoice3 ] }

    it 'returns invoices sorted by most current date' do
      expect(described_class).to receive(:most_current_invoices).with(clear_cache).and_return([invoice3, invoice2, invoice1])
      described_class.most_current_invoices(false)
    end
  end

  describe ".invoices_within_last_year" do 
    let(:invoice1) { Fabricate(:invoice) }
    let(:invoice2) { Fabricate(:invoice, charges_total: 20, period_end: Date.today.prev_month.to_s, period_start: Date.today.beginning_of_month.to_s) }
    let(:invoice3) { Fabricate(:invoice, charges_total: 20, period_end: (Date.today - 2.months).to_s , period_start: Date.today.prev_month.to_s) }
    let(:invoices) { [invoice1, invoice2, invoice3 ] }

    it "returns invoices from within the last year" do
      expect(described_class).to receive(:invoices_within_last_year).with(clear_cache).and_return([invoice3, invoice2])
      described_class.invoices_within_last_year(clear_cache)
    end
  end
end
