require 'spec_helper'

describe Purchase  do  
    it "has a total amound" do
      purchase = Purchase.new
      purchase.total_amount = 1000
      purchase.total_amount.should eql 1000
    end

    it "has a description" do
      purchase = Purchase.new
      purchase.description = "sometext"
      purchase.description.should eql "sometext"
    end
end