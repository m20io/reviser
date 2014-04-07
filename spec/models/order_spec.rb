require 'spec_helper'

describe Order do 
  subject { Order.new }
  
  it "support reading and writing the agency reference" do
    proofreading_agency = ProofreadingAgency.new
    subject.proofreading_agency = proofreading_agency
    subject.proofreading_agency.should equal proofreading_agency
  end

end