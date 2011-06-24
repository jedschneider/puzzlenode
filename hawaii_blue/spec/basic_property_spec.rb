require 'spec_helper'

describe "BasicProperty" do
  let(:property) {(Object.new().extend BasicProperty) }

  describe "nightly rate" do
    subject {property}
    it { should respond_to(:nightly_rate).with(1).argument }
    it { should respond_to(:nightly_rate).with(0).arguments }

    it "should define the nightly rate for a given property" do
      property = {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}.extend BasicProperty
      property.nightly_rate(Date.new).should == 250.0
    end
  end
end
