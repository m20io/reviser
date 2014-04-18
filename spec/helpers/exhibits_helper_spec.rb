require 'spec_helper'

describe ExhibitsHelper do
  subject { Object.new.extend ExhibitsHelper }
  let(:context) { double("context") }
  let(:order) { Order.new }

  it "decorates unpaid orders with an UnpaidOrderExhibit" do
    order.stub(:is_paid?) { false }
    subject.exhibit(order,context).should be_kind_of UnpaidOrderExhibit
  end

  it "dont decorates object it dont know" do
    object = Object.new
    subject.exhibit(object, context).should equal object
  end
end