require 'spec_helper'

describe OrderProcessor do
  let(:local_order) { OpenStruct.new({ })}
  subject { OrderProcessor.new(local_order) }
  
  it "creates an instance with an order" do
    expect{ subject }.to_not raise_error
  end

  it "gives access to a purchase for the subject" do
    object = OpenStruct.new
    subject.purchase = object
    subject.purchase.should equal object
  end

  it "accecpts a paypal gateway" do
    some_gateway = double
    subject.paypal_gateway = some_gateway
    subject.paypal_gateway.should equal some_gateway
  end

  describe "#run" do
    let(:local_order) { OpenStruct.new }
    let(:local_purchase) { OpenStruct.new }
    let(:mock_gateway) { double("paypal_gateway") }
    subject(:subject) { OrderProcessor.new(local_order) }

    before do 
      subject.purchase_factory = ->{ local_purchase }
      mock_gateway.stub(:prepare_payment)
      mock_gateway.stub(:approval_url)
      subject.paypal_gateway = mock_gateway
    end

    it "creates a pruchase for the order" do
      subject.run
      subject.purchase.should be_present
    end

    it "should assign the purchase to the order" do
      subject.run
      subject.subject.purchase.should equal local_purchase
    end

    it "hands the purchase to its paypal gateway" do
      expect(subject.paypal_gateway).
        to receive(:prepare_payment).with(local_purchase).once
      subject.run
    end

    it "provides the redirect url after processing" do
      mock_gateway.stub(:approval_url).and_return("http://www.some-example-page.de")
      subject.run
      subject.payment_redirect_url.should eql "http://www.some-example-page.de"
    end
  end
end