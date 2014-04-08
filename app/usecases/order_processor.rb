class OrderProcessor

  attr_reader :subject, :payment_redirect_url
  attr_writer :purchase_factory
  attr_accessor :purchase, :paypal_gateway

  class InvalidOrderError < StandardError; end

  def initialize(subject)
    @subject = subject
  end

  def run
    self.purchase = purchase_factory.call
    self.subject.purchase = self.purchase
    self.paypal_gateway.prepare_payment(self.purchase)
    self.payment_redirect_url = self.paypal_gateway.approval_url
  end

  private 
  def payment_redirect_url=(value)
    @payment_redirect_url = value
  end

  def purchase_factory
    @purchase_factory ||= Purchase.public_methods(:new)
  end

end