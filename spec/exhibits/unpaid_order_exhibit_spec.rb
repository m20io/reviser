require 'spec_helper'

describe UnpaidOrderExhibit do  

  let(:order) { OpenStruct.new(email: "EMAIL", raw_text: "TEXT")}
  let(:context) { double('context', render: true ) }
  subject { UnpaidOrderExhibit.new(order,context) }
  
  it "delegates methods calls to the order" do
    subject.email.should eql "EMAIL"
    subject.raw_text.should eql "TEXT"
  end

  it "renders the unpaid order partial" do
    context.stub(:render).with(partial: "orders/unpaid_status", 
      locals: {order: subject}) { "UNPAID_ORDER_HTML"}
    subject.render_status.should eql "UNPAID_ORDER_HTML"
  end
end