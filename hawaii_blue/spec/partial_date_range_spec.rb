require 'spec_helper'

describe PartialDateRange do
  it "should know a date falls within the range" do
    range = PartialDateRange.new(PartialDate.new("05-04"), PartialDate.new("05-10"))
    range.include?("05-09").should be true
  end

  it "should accept strings and ParitalDate class objects interchangably as parameters" do
    finish = PartialDate.new("05-10")
    expect {PartialDateRange.new("03-09", finish) }.to_not raise_error
  end

  it "should be able to know when a date wraps a year" do
    range = PartialDateRange.new("05-14", "04-30")
    range.include?("05-15").should == true
  end
end
