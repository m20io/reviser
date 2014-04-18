require 'spec_helper'

describe Order do 
  subject { Order.new }
  
  it 'has a presistent purchase associated' do
    purchase = Purchase.create
    subject.purchase = purchase
    subject.save
    Order.find(subject.id).purchase.should eql purchase    
  end

  it 'it is paid? if its purchase is_done?' do
    subject.stub(:purchase).and_return OpenStruct.new(is_done?: true)
    subject.is_paid?.should be_true
  end

  it 'it is not paid? if its purchase not done?' do
    subject.stub(:purchase).and_return OpenStruct.new(is_done?: false)
    subject.is_paid?.should be_false
  end

end
