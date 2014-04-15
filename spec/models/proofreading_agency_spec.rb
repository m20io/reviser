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

  it "can store orders" do
    local_order = OpenStruct.new
    subject.add_to_backlog local_order
    subject.backlog.should include local_order
  end

  it "knows the number of orders" do
    subject.stub(:backlog).and_return 5.times.map { |dev_null| OpenStruct.new }
    subject.backlog_count.should eql 5
  end

  it "finds all orders for index" do
    subject.find_orders_for_index.should eql Order.all.to_a
  end

  it "find an order by id" do
    order = Order.new
    order.save
    subject.find_order(order.id).should eql order
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

    it "set the agency refernce of the order to it self" do
      subject.new_order.proofreading_agency.should equal subject
    end

    it "stores a reference to the order" do
      subject.new_order
      subject.backlog.should include local_order
    end
  end

  describe "#process_order" do
    let(:local_order) { OpenStruct.new }
    let(:local_order_order_processor) { OpenStruct.new }

    it "return a new order processor" do
      subject.order_processor_factory = ->(args){ local_order_order_processor }
      subject.process_order(nil).should eql local_order_order_processor
    end

    it "takes an order and hands it two the order processor factory" do
      subject.order_processor_factory = ->(args){ OpenStruct.new(order: args) }
      subject.process_order(local_order).order.should eql local_order
    end

    it "sets a paypal gateway to the processor" do
      local_order_order_processor.stub(:paypal_gateway=)
      expect(local_order_order_processor).to receive(:paypal_gateway=).once
      subject.order_processor_factory = ->(args){ local_order_order_processor }
      
      subject.process_order(local_order)
    end
  end

end