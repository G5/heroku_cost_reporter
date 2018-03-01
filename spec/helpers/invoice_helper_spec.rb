require 'rails_helper'

describe InvoiceHelper do
  describe '#month' do
    let(:invoice) { Fabricate(:invoice, charges_total: 20, period_end: "2018-03-01", period_start: "2018-02-01") }
    it 'returns month name as text' do
      expect(helper.month(invoice)).to eq('February')
    end
  end
end
