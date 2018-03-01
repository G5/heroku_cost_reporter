module InvoiceHelper
  def month(invoice)
    invoice.period_start.to_date.strftime("%B") if invoice.period_start
  end
end
