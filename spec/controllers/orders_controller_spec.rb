require 'spec_helper'

describe OrdersController do
  describe '#create' do
    let(:agency_mock) { double("agency_mock") }
    let(:order_parmas) { {order: { "raw_text" => "some long text", "email" => "mail2@example.de" }} }
    let(:local_order_processor) { OpenStruct.new({ payment_redirect_url: "https://www.payment.com" } )}
    
    before(:each) do
      agency_mock.stub(:new_order)
      agency_mock.stub(:process_order).and_return(local_order_processor)
      agency_mock.stub(:payment_redirect_url)
      # singleton root object
      stub_const("THE_PROOFREADING_AGENCY", agency_mock)
    end

    it "calls new order with params" do
      expect(agency_mock).to receive(:new_order).with(order_parmas[:order]).once
      
      post :create, order_parmas
    end

    it "process the order" do
      local_order = OpenStruct.new
      agency_mock.stub(:new_order).and_return(local_order)
      expect(agency_mock).to receive(:process_order).with(local_order).once
      
      post :create, order_parmas
    end

    it "redirects to the payment url" do
      post :create, order_parmas

      response.should redirect_to "https://www.payment.com"
    end
  end
  
end