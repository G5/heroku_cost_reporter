class InvoicesController < ApplicationController
  def index
    @invoices = Heroku::Invoice.all_invoices
  end
end
