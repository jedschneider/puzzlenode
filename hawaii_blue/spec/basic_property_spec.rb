require 'spec_helper'

describe BasicProperty do
  it "should define the nightly rate" do
    property = {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}
    property.extend BasicProperty
    property.nightly_rate.should == 250.0
    property.nightly_rate(Date.new).should == 250.0
  end
end
