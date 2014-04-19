require 'paypal-sdk-rest'

class PaypalGateway
  include PayPal::SDK::REST
  attr_writer :payment_factory, :transaction_factory, :return_url, :cancel_url
  attr_accessor :payment

  class PaymentError < StandardError; end

  def prepare_payment(object)
    self.payment = build_payment_from_purchase(object) 
    unless self.payment.create
      Rails.logger.error "Paypal payment creation failed. \n #{self.payment.error}"
      raise PaymentError, self.payment.error['message'], caller
    end
  end

  def execute_payment(purchase)
    self.payment = find_payment(purchase.payment_id)
    unless self.payment.execute(purchase.payer_id)
      Rails.logger.error "Paypal payment creation failed. \n #{self.payment.error}"
      raise PaymentError, self.payment.error['message'], caller
    end
  end

  def payment_id
    self.payment.id
  end

  def approval_url
    self.payment.links.select{|link| link["rel"] == "approval_url"}.first["href"]
  end

  def return_url
    @return_url ||  Rails.application.routes.url_helpers.purchase_processor_execute_url(host: '127.0.0.1:3000')
  end

  def cancel_url
    @cancel_url || Rails.application.routes.url_helpers.purchase_processor_destory_url(host: '127.0.0.1:3000')
  end

  private
  def find_payment(payment_id)
    Payment.find(payment_id)
  end

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