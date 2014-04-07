require 'spec_helper'

describe ProofreadingAgency do 
  subject { ProofreadingAgency.new }

  it "has no orders" do
    subject.orders.should be_empty
  end

  describe "#new_order" do
    let(:local_order) { OpenStruct.new }

    before do      
      subject.order_factory = ->{ local_order }
    end

    it "returns a new order" do
      subject.new_order.should equal local_order
    end

    it "set the agncy refernce of the order to it self" do
      subject.new_order.proofreading_agency.should equal subject
    end
  end
end