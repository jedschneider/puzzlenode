require 'spec_helper'

describe %Q|A Property: {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}|  do
  subject { {"name"=>"Paradise Inn", "rate"=>"$250", "cleaning fee"=>"$120"}.extend Property }

  it {should respond_to(:name, :sales_tax, :cleaning_fee, :quote, :rental_cost, :nightly_rate) }

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

  context do
    before { subject.extend BasicProperty }
    it "should know about its rental cost" do
      subject.rental_cost(["2011-05-06", "2011-05-07"]).should == 500.0
    end

    it "should format the quote accordingly" do
      subject.quote("2011/05/05 - 2011/05/10").should == "Paradise Inn: $1426.36"
    end

    it "should report the total cost for a requested reservation period" do
      sales_tax = 1.0411416
      subject.total("2011/05/05 - 2011/05/10").should == (((5*250) + 120) * sales_tax)
    end
  end

end
