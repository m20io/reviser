class ProofreadingAgency
  attr_reader :backlog
  attr_writer :order_factory, :order_processor_factory

  def initialize
    @backlog = []
  end

  def name
    "Reviser Online"
  end

  def claim
    "Lektorat für zeitnahe Korrektur kuzer Texte."
  end

  def add_to_backlog(object)
    @backlog << object
  end 
    
  def backlog_count
    backlog.count
  end

  def new_order(*args)
    order_factory.call(*args).tap do |order|
      order.proofreading_agency = self
      add_to_backlog order
    end
  end

  def process_order(*args)
    order_processor = order_processor_factory.call(*args)
    order_processor.paypal_gateway = PaypalGateway.new

    order_processor
  end


  private
  def order_factory
    @order_factory ||= Order.public_method(:new)
  end

  def order_processor_factory
    @order_processor_factory ||= OrderProcessor.public_method(:new)
  end
end