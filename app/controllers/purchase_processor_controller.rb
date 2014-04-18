class PurchaseProcessorController < ApplicationController

  def execute
    order = @proofreading_agency.find_in_backlog(params[:order_id])
    purchase_processor = @proofreading_agency.process_order(order)
    purchase_processor.run_execute(params[:PayerID])
    if purchase_processor.executed_successful?
      flash[:notice] = 'Vielen Dank - Ihre Bezahlung wurde erfolgreich durchgeführt!'
    else
      flash[:error] = 'Leider wurde konnten wir Ihre Zahlung nicht durchführen!'
    end
    redirect_to order_path(order)
  end

  def destroy

  end
end