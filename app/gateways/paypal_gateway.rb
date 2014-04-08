class PaypalGateway

  attr_writer :payment_factory, :transaction_factory
  attr_accessor :payment, :return_url, :cancel_url

  class PaymentError < StandardError; end

  def prepare_payment(object)
    self.payment = build_payment_from_purchase(object) 
    unless self.payment.create
      Rails.logger.error "Paypal payment creation failed. \n #{self.payment.error}"
      raise PaymentError
    end
  end

  def paypal_payment_id
    self.payment.id
  end

  def approval_url
    self.payment.links.select{|link| link["rel"] == "approval_url"}.first["href"]
  end

  private
  def payment_factory
    @payment_factory ||= Payment.public_method(:new)
  end

  def transaction_factory
    @transaction_factory ||=Transaction.public_method(:new)
  end

  def build_payment_from_purchase(purchase)
    payment = payment_factory.call
    payment.intent = "sale"
    payment.payer.payment_method = "paypal"
    payment.redirect_urls.return_url = self.return_url
    payment.redirect_urls.cancel_url = self.cancel_url
    transaction = transaction_factory.call
    transaction.amount.total = purchase.total_amount
    transaction.amount.currency = "EUR" 
    transaction.description = purchase.description
    payment.transactions << transaction

    payment
  end
end