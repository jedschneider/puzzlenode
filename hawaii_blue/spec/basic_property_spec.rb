require 'spec_helper'

describe BasicProperty do
  subject {({"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}.extend BasicProperty)}
  it_behaves_like "a property"
  
  context "the implemented methods"
    its(:nightly_rate) {should == 250.0}
    
    it "should format the quote accordingly" do
      subject.quote("2011/05/05 - 2011/05/10").should == "Paradise Inn: $1426.36"
    end

    it "should report the total cost for a requested reservation period" do
      sales_tax = 1.0411416
      subject.total("2011/05/05 - 2011/05/10").should == (((5*250) + 120) * sales_tax)
    end
end

