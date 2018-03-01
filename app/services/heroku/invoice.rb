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

    def self.most_current_invoices(clear_cache)
      self.all_invoices(clear_cache).sort_by(&:period_start).reverse!
    end

    def self.invoices_within_last_year(clear_cache)
      invoices = self.most_current_invoices(clear_cache)
      latest_invoice = invoices.first
      invoices = invoices.select { |invoice| invoice if invoice.period_start > Date.parse(latest_invoice.period_start).prev_year.to_s }
    end

    def initialize(args = {})
      super(args)
    end
  end
end
