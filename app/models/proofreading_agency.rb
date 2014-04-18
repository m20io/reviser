class ProofreadingAgency
  include Singleton

  attr_writer :order_factory, :purchase_processor_factory

  def name
    "Reviser Online"
  end

  def claim
    "Lektorat für zeitnahe Korrektur kuzer Texte."
  end

  def add_to_backlog(object)
     object.save
  end 
    
  def backlog_count
    backlog.count
  end

  def backlog
    Order.all.to_a
  end

  def find_in_backlog(id)
    Order.find(id)
  end

  def new_order(*args)
    order_factory.call(*args).tap do |order|
      add_to_backlog order
    end
  end

  def process_order(*args)
    purchase_processor = purchase_processor_factory.call(*args)
    purchase_processor.paypal_gateway = PaypalGateway.new

    purchase_processor
  end


  private
  def order_factory
    @order_factory ||= Order.public_method(:new)
  end

  def purchase_processor_factory
    @purchase_processor_factory ||= PurchaseProcessor.public_method(:new)
  end
end