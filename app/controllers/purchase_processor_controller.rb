class PurchaseProcessorController < ApplicationController

  def execute
    order = @proofreading_agency.find_in_backlog(params[:order_id])
    purchase_processor = @proofreading_agency.process_order(order)
    purchase_processor.run_execute(params[:PayerID])
    redirect_to order_path(order)
  end

  def destroy

  end
end