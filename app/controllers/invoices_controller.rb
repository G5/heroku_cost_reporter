class InvoicesController < ApplicationController
  def index
    @invoices = Heroku::Invoice.invoices_within_last_year(clear_cache)
  end

  private
    def clear_cache
      params[:clear_cache].present?
    end
end
