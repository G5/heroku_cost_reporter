class InvoicesController < ApplicationController
  def index
    @invoices = Heroku::Invoice.latest_invoices(clear_cache)
  end

  private
    def clear_cache
      params[:clear_cache].present?
    end
end
