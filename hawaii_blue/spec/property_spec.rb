require 'spec_helper'

describe Property do
  it_behaves_like "a property"
end

describe %Q|A Property: {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}|  do
  subject { {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}.extend Property }

  it "should know about its name" do
    subject.name.should == "Paradise Inn"
  end

  it "should return its cleaning fee" do
    subject.cleaning_fee.should == 120.0
  end

  it "should report 0 for a property without a cleaning fee" do
    property = {"name"=>"Paradise Inn", "rate"=>"$250"}
    property.extend Property
    property.cleaning_fee.should == 0.0
  end

  it "should know about sales tax" do
    subject.sales_tax.should == 1.0411416
  end

  it "should raise an implenetation error when no nightly_rate method is found" do
    property = double("property")
    module Foo; include Property;end
    property.extend Foo
    expect {property.nightly_rate(Date.new)}.to raise_error
  end
end
