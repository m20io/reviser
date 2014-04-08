class PaypalGateway

  attr_writer :payment_factory, :transaction_factory
  attr_accessor :payment

  def prepare_payment(object)
    self.payment = build_payment_from_purchase(object) 
    self.payment.create
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
    transaction = transaction_factory.call
    transaction.amount.total = purchase.total_amount
    transaction.amount.currency = "EUR" 
    transaction.description = purchase.description
    payment.transactions << transaction

    payment
  end

  def approval_link_selection(payment)
    
  end

end