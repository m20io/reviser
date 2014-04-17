require 'spec_helper'

describe Order do 
  subject { Order.new }
  
  it "support reading and writing the agency reference" do
    proofreading_agency = ProofreadingAgency.instance
    subject.proofreading_agency = proofreading_agency
    subject.proofreading_agency.should equal proofreading_agency
  end

  it "is incomplete in the beginning" do
    subject.is_incomplete?.should be_false
  end

end
