require 'spec_helper'

describe OrdersController do
  let(:orders) { [double({id:3}),double] }
  let(:agency_mock) { double(ProofreadingAgency) }

  before(:each) do
    agency_mock.stub(:backlog).and_return orders
    agency_mock.stub(:find_in_backlog).and_return orders.first
    ProofreadingAgency.stub(:instance).and_return agency_mock
  end

  describe '#create' do
    let(:order_parmas) { {order: { "raw_text" => "some long text", "email" => "mail2@example.de" }} }
    let(:local_purchase_processor) { double( { payment_redirect_url: "https://www.payment.com", run_prepare: nil } )}
    
    before(:each) do
      agency_mock.stub(:new_order).and_return(orders.first)
      agency_mock.stub(:process_order).and_return(local_purchase_processor)
      agency_mock.stub(:payment_redirect_url)
      # singleton root object
      ProofreadingAgency.stub(:instance).and_return agency_mock
    end

    it "calls new order with params" do
      expect(agency_mock).to receive(:new_order).with(order_parmas[:order]).once
      
      post :create, order_parmas
    end

    it "process the order" do
      expect(agency_mock).to receive(:process_order).with(orders.first).once
      
      post :create, order_parmas
    end
    it "redirects to the payment url" do
      post :create, order_parmas
      response.should redirect_to "https://www.payment.com"
    end
    context 'when there is a paypal payment error' do
      before(:each) do
        local_purchase_processor.stub(:run_prepare).and_raise PaypalGateway::PaymentError
      end
      it 'redirects to order show' do
        post :create, order_parmas
        response.should redirect_to order_path(orders.first)
      end

      it 'display an errors message' do
        post :create, order_parmas
        flash[:error].should be_present
      end
    end
  end
  describe '#index' do
    it 'assign the orders from the backlog' do
      get :index
      assigns(:orders).should eql orders
    end

    it 'renders the index template' do
      get :index
      response.should render_template :index
    end
  end

  describe '#show' do
    it 'assign an order and from the agency backlog' do
      expect(agency_mock).to receive(:find_in_backlog).with('some_id')
      get :show, id: 'some_id'
      assigns(:order).should eql orders.first
    end

    it 'renders the show template' do
      get :show, id: 'some_id'
      response.should render_template :show
    end
  end
end