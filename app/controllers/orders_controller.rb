class OrdersController < ApplicationController
  helper :exhibits
  def create
    current_order = @proofreading_agency.new_order(order_params)
    
    purchase_processor = @proofreading_agency.process_order(current_order)
    begin
      purchase_processor.run_prepare
    rescue PaypalGateway::PaymentError
      flash[:error] = "Ihr Auftrag konnte nicht durchgeführt werden, da zurzeit keine Zahlung über PayPal möglich ist."
      redirect_to order_path(current_order)
    else
      redirect_to purchase_processor.payment_redirect_url  
    end
  end

  def index 
    @orders = @proofreading_agency.backlog
  end

  def show
    @order = @proofreading_agency.find_in_backlog(params[:id])
  end

  private
  def order_params
    params.require(:order).permit(:raw_text,:email)
  end
end
