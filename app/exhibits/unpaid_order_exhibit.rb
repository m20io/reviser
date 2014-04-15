class UnpaidOrderExhibit
  
  attr_reader :order
  delegate :email,    to: :order
  delegate :raw_text, to: :order

  def initialize(order,context)
    @order = order
    @context = context
  end

  def render_status
    @context.render(partial: 'orders/unpaid_status', locals: { order: self })
  end
end