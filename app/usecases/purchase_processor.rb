class PurchaseProcessor

  attr_reader :subject, :payment_redirect_url
  attr_writer :purchase_factory
  attr_accessor :purchase, :paypal_gateway

  class InvalidOrderError < StandardError; end

  def initialize(subject)
    @subject = subject
    self.purchase = subject.purchase unless subject.purchase.present?
  end

  def run_prepare
    self.purchase = purchase_factory.call
    self.subject.purchase = self.purchase
    self.paypal_gateway.prepare_payment(self.purchase)
    self.purchase.payment_id = paypal_gateway.payment_id
    self.purchase.transition_to_waiting_for_approval!
    self.payment_redirect_url = self.paypal_gateway.approval_url
  end

  def run_execute(payer_id)
    self.purchase.payer_id = payer_id
    self.paypal_gateway.execute_payment(purchase)
    self.purchase.transition_to_done!
  end

  private 
  def payment_redirect_url=(value)
    @payment_redirect_url = value
  end

  def purchase_factory
    @purchase_factory ||= Purchase.public_method(:new)
  end

end