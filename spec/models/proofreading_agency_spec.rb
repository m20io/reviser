require 'spec_helper'

describe ProofreadingAgency do 
  subject { ProofreadingAgency.new }

  it "has no backlog" do
    subject.backlog.should be_empty
  end

  it "knows the number of orders" do
    subject.stub(:backlog).and_return 5.times.map { |dev_null| OpenStruct.new }
    subject.backlog_count.should eql 5
  end

  describe "#new_order" do
    let(:local_order) { OpenStruct.new }
    let(:order_params) { { raw_text: "sometext", email: "mail@example.com"} }

    before do      
      subject.order_factory = ->{ local_order }
    end

    it "returns a new order" do
      subject.new_order.should equal local_order
    end

    it "set the agency refernce of the order to it self" do
      subject.new_order.proofreading_agency.should equal subject
    end

    it "gives the parameter to the factory method" do
      subject.order_factory = ->(hash){ OpenStruct.new(hash) }
      
      order = subject.new_order(order_params) 
      order.raw_text.should eql order_params[:raw_text]
      order.email.should eql order_params[:email]
    end
  end
end