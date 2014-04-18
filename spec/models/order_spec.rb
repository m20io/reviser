require 'spec_helper'

describe Order do 
  subject { Order.new }
  
  it "support reading and writing the agency reference" do
    proofreading_agency = ProofreadingAgency.instance
    subject.proofreading_agency = proofreading_agency
    subject.proofreading_agency.should equal proofreading_agency
  end
  
  it "has a presistent purchase associated" do
    purchase = Purchase.create
    subject.purchase = purchase
    subject.save
    Order.find(subject.id).purchase.should eql purchase    
  end

end
