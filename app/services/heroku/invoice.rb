module Heroku
  class Invoice < Base
    attr_accessor :charges_total,
                  :credits_total,
                  :total,
                  :period_end,
                  :period_start,
                  :state

    def self.all_invoices
      response = Request.where('account/invoices')
      invoices = response.map { |invoice| Invoice.new(invoice) }
    end

    # def self.find(invoice_id)
      # response = Request.get("accounts/invoices/#{id}")
      # Invoice.new(response)
    # end

    def initialize(args = {})
      super(args)
    end
  end
end
