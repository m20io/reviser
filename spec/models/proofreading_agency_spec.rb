require 'spec_helper'

describe ProofreadingAgency do 
  subject { ProofreadingAgency.send(:new) }

  it "has a name and a claim" do
    subject.name.should be_present
    subject.claim.should be_present
  end

  it "has an empty backlog" do
    subject.backlog.should be_empty
  end

  it "saves orders" do
    local_order = OpenStruct.new
    expect(local_order).to receive(:save).once
    subject.add_to_backlog local_order
  end

  it "knows the number of orders" do
    subject.stub(:backlog).and_return 5.times.map { |dev_null| OpenStruct.new }
    subject.backlog_count.should eql 5
  end

  it "returns all order in the backlog" do
    subject.backlog.should eql Order.all.to_a
  end

  it "find an order in the backlog by its id" do
    order = Order.new
    order.save
    subject.find_in_backlog(order.id).should eql order
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

    it "gives the parameter to the factory method" do
      subject.order_factory = ->(hash){ OpenStruct.new(hash) }
      
      order = subject.new_order(order_params) 
      order.raw_text.should eql order_params[:raw_text]
      order.email.should eql order_params[:email]
    end

    it "adds the order to the backlog" do
      expect(subject).to receive(:add_to_backlog).with(local_order).once
      subject.new_order
    end
  end

  describe "#process_order" do
    let(:local_order) { OpenStruct.new }
    let(:local_purchase_processor) { OpenStruct.new }

    it "return a new order processor" do
      subject.purchase_processor_factory = ->(args){ local_purchase_processor }
      subject.process_order(nil).should eql local_purchase_processor
    end

    it "takes an order and hands it two the order processor factory" do
      subject.purchase_processor_factory = ->(args){ OpenStruct.new(order: args) }
      subject.process_order(local_order).order.should eql local_order
    end

    it "sets a paypal gateway to the processor" do
      local_purchase_processor.stub(:paypal_gateway=)
      expect(local_purchase_processor).to receive(:paypal_gateway=).once
      subject.purchase_processor_factory = ->(args){ local_purchase_processor }
      
      subject.process_order(local_order)
    end
  end

end