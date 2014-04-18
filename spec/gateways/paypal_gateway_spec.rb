require 'spec_helper'

describe PaypalGateway do
  it "reads the api credential" do
    PayPal::SDK.configure.client_id.should eql "client_id"
    PayPal::SDK.configure.client_secret.should eql "client_secret"
  end

  describe '#prepare_payment' do
    subject { PaypalGateway.new }
    let(:purchase) { OpenStruct.new({total_amount: "42.24", description: "text"}) }
    let(:local_mock_payment) { double("payment") }
    
    context "when setting payment values" do
      before(:each) do
        subject.payment_factory = ->{ mock_payment }
        subject.return_url = "http://return/"
        subject.cancel_url = "http://cancel/"
        subject.prepare_payment(purchase)
        @it = subject.payment
      end

      it "sets the payment intent is sale" do
        @it.intent.should eql "sale"
      end
      
      it "sets the payment payer method to paypal" do
        @it.payer.payment_method.should eql "paypal"
      end

      it "sets the transactions according to the purchase" do
        @it.transactions.first.amount.total.should eql purchase.total_amount.to_s
        @it.transactions.first.amount.currency.should eql "EUR"
        @it.transactions.first.description.should eql purchase.description
      end

      it "sets the return and cancel url" do
        @it.redirect_urls.return_url.should eql "http://return/"
        @it.redirect_urls.cancel_url.should eql "http://cancel/"
      end
    end

    it "calls create for the payment" do
      local_mock_payment.stub(:create).and_return true
      subject.stub(:build_payment_from_purchase).and_return(local_mock_payment)
      expect(local_mock_payment).to receive(:create).once
      subject.prepare_payment(purchase)
    end

    context "with a successful created payment" do
      before(:each) do
        local_mock_payment.stub(:create).and_return true
        local_mock_payment.stub(:id).and_return "PAY-123456789"
        local_mock_payment.stub(:links).and_return mock_links()
        subject.stub(:build_payment_from_purchase).and_return(local_mock_payment)

      end

      it "stores the payment id" do 
        subject.prepare_payment(purchase)
        subject.payment_id.should eql "PAY-123456789"
      end

      it "stores the approval url" do
        subject.prepare_payment(purchase)
        subject.approval_url.should eql "http://test2"
      end
    end

    context "with a unsuccessful created payment" do
      before(:each) do
        local_mock_payment.stub(:create).and_return false
        local_mock_payment.stub(:error).and_return({ error: "error!" })
        subject.stub(:build_payment_from_purchase).and_return(local_mock_payment)
      end

      it "raises an PaymentError" do
        expect{ subject.prepare_payment(purchase) }.to raise_error PaypalGateway::PaymentError
      end

      it "logs a messages" do
        Rails.logger.should_receive(:error) 
        subject.prepare_payment(purchase) rescue PaypalGateway::PaymentError
      end
    end
  end

  describe '#execute_payment' do
    it 'executes the payment with the payerId' do
      @it = PaypalGateway.new
      payment = double(PaypalGateway::Payment)
      payment.stub(:execute)
      PaypalGateway::Payment.stub(:find).and_return payment
      purchase = double(Purchase)
      purchase.stub(:payment_id).and_return 'a_payment_id'
      purchase.stub(:payer_id).and_return 'a_payer_id'

      expect(payment).to receive(:execute).with('a_payer_id').once
      @it.execute_payment(purchase)
    end
  end

  def mock_payment
    OpenStruct.new( { payer: OpenStruct.new, transactions: [], redirect_urls: OpenStruct.new, create: true })
  end

  def mock_links
    [{ "href"=> "http://test1", "rel"=> "self","method"=> "GET" },
     { "href"=> "http://test2", "rel"=> "approval_url", "method"=> "REDIRECT" },
     { "href"=> "http://test3", "rel"=> "execute", "method"=> "POST" }]
  end
end