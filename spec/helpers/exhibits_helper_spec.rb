require 'spec_helper'

describe ExhibitsHelper do
  subject { Object.new.extend ExhibitsHelper }
  let(:context) { double("context") }

  it "decorates unpaid orders with an UnpaidOrderExhibit" do
    order = Order.new
    order.stub(:is_incomplete?) { false }
    subject.exhibit(order,context).should be_kind_of UnpaidOrderExhibit
  end

  it "dont decorates object it dont know" do
    object = Object.new
    subject.exhibit(object, context).should equal object
  end
end