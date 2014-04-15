class OrdersController < ApplicationController
  helper :exhibits
  def create
    current_order = @proofreading_agency.new_order(order_params)
    order_processor = @proofreading_agency.process_order(current_order)
    order_processor.run
    
    redirect_to order_processor.payment_redirect_url
  end

  def index 
    @orders = @proofreading_agency.find_orders_for_index
  end

  def show
    @order = @proofreading_agency.find_order(params[:id])
  end

  private
  def order_params
    params.require(:order).permit(:raw_text,:email)
  end
end
