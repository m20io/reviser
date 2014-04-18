require 'spec_helper'

describe Purchase  do  
  subject { Purchase.new }
    it 'has a total amound' do
      subject.total_amount = 1000.01
      subject.total_amount.should eql 1000.01
    end

    it 'has a description' do
      subject.description = 'sometext'
      subject.description.should eql 'sometext'
    end
    it 'has a payment_id' do
      subject.payment_id = 'a_payment_id'
      subject.payment_id.should eql 'a_payment_id'
    end

    it 'has a payer_id' do
      subject.payer_id = 'a_payer_id'
      subject.payer_id.should eql 'a_payer_id'
    end
    it 'may has a persistent order' do
      subject.order = Order.new
      subject.save

      Purchase.find(subject.id).order.should eql subject.order
    end

    it 'is incomplete in the beginning' do
      subject.is_incomplete?.should be_true
    end

    context 'with transit to waiting for approval' do
      it 'transits from incomplete' do
        subject.transition_to_waiting_for_approval!
        subject.state.should eql :waiting_for_approval
      end

      it 'raises an illegal transition expection if state not incomplete' do
        subject.state = :crazy_state
        expect{ subject.transition_to_waiting_for_approval! }.to raise_error(Purchase::IllegalTransition)
      end


    end
end