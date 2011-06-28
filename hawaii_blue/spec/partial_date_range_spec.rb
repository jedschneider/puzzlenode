require 'spec_helper'

RSpec::Matchers.define :contain_the_date do |expected|
  match do |actual|
    actual.send(:includes?, expected) #=> range.includes? "05-14"
  end
end

describe PartialDateRange do
  it "should accept strings and ParitalDate class objects interchangably as parameters" do
    finish = PartialDate.new "05-10"
    expect { PartialDateRange.new("03-09", finish) }.to_not raise_error
  end

  describe "should know a date falls within the range from 05-04 to 05-10" do
    subject { PartialDateRange.new("05-04", "05-10") }
    specify { should contain_the_date "05-09" }
  end

  describe "a range that wraps the year end from 05-14 to 04-30" do
    subject { PartialDateRange.new "05-14", "04-30" }
    specify { should contain_the_date "05-15"  }
  end
end
