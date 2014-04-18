require 'spec_helper'

describe PurchaseProcessor do
  let(:local_purchase) { OpenStruct.new }
  let(:local_order) { OpenStruct.new }
  let(:mock_gateway) { double('paypal_gateway') }
  subject { PurchaseProcessor.new(local_order) }
  
  it 'creates an instance with an order' do
    expect{ subject }.to_not raise_error
  end

  it 'gives access to a purchase for the subject' do
    object = OpenStruct.new
    subject.purchase = object
    subject.purchase.should equal object
  end

  it 'accepts a paypal gateway' do
    some_gateway = double
    subject.paypal_gateway = some_gateway
    subject.paypal_gateway.should equal some_gateway
  end

  it 'create a Purchase' do
    subject.send(:purchase_factory).call.should be_a Purchase
  end

  describe '#run_prepare' do
    before do 
      subject.purchase_factory = ->{ local_purchase }
      mock_gateway.stub(:prepare_payment)
      mock_gateway.stub(:approval_url)
      mock_gateway.stub(:payment_id)
      subject.paypal_gateway = mock_gateway
    end

    it 'creates a purchase for the order' do
      subject.run_prepare
      subject.purchase.should be_present
    end

    it 'should assign the purchase to the order' do
      subject.run_prepare
      subject.subject.purchase.should equal local_purchase
    end

    it 'transit purchase to state waiting_for_approval' do
      expect(local_purchase).to receive(:transition_to_waiting_for_approval!).once()
      subject.run_prepare
    end

    it 'hands the purchase to its paypal gateway' do
      expect(subject.paypal_gateway).
        to receive(:prepare_payment).with(local_purchase).once
      subject.run_prepare
    end

    it 'provides the redirect url after processing' do
      mock_gateway.stub(:approval_url).and_return('http://test')
      subject.run_prepare
      subject.payment_redirect_url.should eql 'http://test'
    end

    it 'stores the payment id in purchase' do
      mock_gateway.stub(:payment_id).and_return 'some_payment_id'
      subject.run_prepare
      subject.purchase.payment_id.should eql 'some_payment_id'
    end
  end

  describe '#run_execute' do
    before(:each) do
      mock_gateway.stub(:execute_payment)
      subject.purchase = local_purchase
      subject.paypal_gateway = mock_gateway
    end
    it 'hands the purchase to the paypal_gateway' do
      expect(mock_gateway).to receive(:execute_payment)
        .with(local_purchase).once
      subject.run_execute('some_id')
    end

    it 'transits the purchase to done' do
      expect(local_purchase).to receive(:transition_to_done!).once
      subject.run_execute('some_id')
    end
  end
end