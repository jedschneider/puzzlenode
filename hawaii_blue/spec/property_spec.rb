require 'spec_helper'

describe Property do
  it "should raise an implenetation error when no nightly_rate method is found" do
    property = double("property")
    module Foo; include Property;end
    property.extend Foo
    expect {property.nightly_rate(Date.new)}.to raise_error
  end

  it "should respond to the method quote with an input of a reservation period" do
    property = {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}
    property.extend BasicProperty
    expect {property.quote("2011/05/07 - 2011/05/20")}.to_not raise_error
  end

  it "should format the quote accordingly" do
    sales_tax = 1.0411416
    property = {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}
    property.extend BasicProperty
    property.quote("2011/05/05 - 2011/05/10").should == "Paradise Inn: $1426.36"
  end

  it "should report the total cost for a requested reservation period" do
    sales_tax = 1.0411416
    property = {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}
    property.extend BasicProperty
    property.total("2011/05/05 - 2011/05/10").should == (((5*250) + 120) * sales_tax)
  end

  it "should know about its rental cost" do
    property = {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}
    property.extend BasicProperty
    property.rental_cost(["2011-05-06", "2011-05-07"]).should == 500
  end

  it "should know about its name" do
    property = {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}
    property.extend Property
    property.name.should == "Paradise Inn"
  end

  it "should return its cleaning fee" do
    property = {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}
    property.extend Property
    property.cleaning_fee.should == 120.0
  end

  it "should report 0 for a property without a cleaning fee" do
    property = {"name"=>"Paradise Inn", "rate"=>"$250"}
    property.extend Property
    property.cleaning_fee.should == 0.0
  end

  it "should know about sales tax" do
    property = {"name"=>"Paradise Inn", "rate"=>"$250"}
    property.extend Property
    property.sales_tax.should == 1.0411416
  end
end
