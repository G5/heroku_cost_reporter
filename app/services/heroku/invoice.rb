module Heroku
  class Invoice < Base
    attr_accessor :charges_total,
                  :credits_total,
                  :total,
                  :period_end,
                  :period_start,
                  :state,
                  :number
    CACHE_DEFAULTS = { expires_in: 7.days, force: false }

    def self.all_invoices(clear_cache)
      cache = CACHE_DEFAULTS.merge({ force: clear_cache })
      response = Request.where('account/invoices', cache)
      response.map { |invoice| Invoice.new(invoice) }
    end

    def self.latest_invoices(clear_cache)
      invoices = self.all_invoices(clear_cache).sort_by(&:period_start).reverse!
      first_invoice = invoices.first
      invoices = invoices.select { |invoice| invoice if invoice.period_start > Date.parse(first_invoice.period_start).prev_year.to_s }
    end

    def initialize(args = {})
      super(args)
    end

    def last_year_to_date(date)
      year + month + (day - 1)
    end

    def month
      period_start.to_date.strftime("%B") if period_start
    end
  end
end
