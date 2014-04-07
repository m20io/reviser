class ProofreadingAgencyController < ApplicationController
  def show
  	@proofreading_agency = ProofreadingAgency.new
    @order = @proofreading_agency.new_order
  end
end
