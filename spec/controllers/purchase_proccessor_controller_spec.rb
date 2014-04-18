require 'spec_helper'

describe PurchaseProcessorController do 
  describe '#update' do
    let(:order) { OpenStruct.new( id: 3 ) }
    let(:purchase_processor) { double "purchase_processor" }
    let(:agency_mock) { double "agency" }

    before(:each) do
      agency_mock.stub(:find_in_backlog).and_return order 
      agency_mock.stub(:process_order).and_return purchase_processor
      purchase_processor.stub(:run_execute)
      ProofreadingAgency.stub(:instance).and_return agency_mock
    end

    it 'creates and order processor and runs execute' do
      expect(agency_mock).to receive(:find_in_backlog).with(order.id.to_s).once
      expect(purchase_processor).to receive(:run_execute).with('AAAAAAAAAAAAA').once

      get :execute, { 'token' => 'EC-10000000000000000', 'PayerID' => 'AAAAAAAAAAAAA', 'order_id' => "#{order.id}" }
    end

    it "redirect to display the order" do
      get :execute, { 'token' => 'EC-10000000000000000', 'PayerID' => 'AAAAAAAAAAAAA', 'order_id' => "#{order.id}" }
      response.should redirect_to order_path(order)
    end
  end

  describe '#destroy' do

  end
end