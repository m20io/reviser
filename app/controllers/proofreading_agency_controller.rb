class ProofreadingAgencyController < ApplicationController
  def show
    @order = @proofreading_agency.new_order
  end
end
