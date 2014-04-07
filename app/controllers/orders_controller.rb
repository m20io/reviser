class OrdersController < ApplicationController
  def create
    @proofreading_agency.new_order(order_params)
    redirect_to root_path, notice: "Neuer Auftrag angelegt."
  end

  private
  def order_params
    params.require(:order).permit(:raw_text,:email)
  end
end
