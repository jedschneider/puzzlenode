require 'spec_helper'

describe PartialDate do

  describe "methods" do
    subject { PartialDate.new("04-06") }
    it { should respond_to(:<=>, :>, :<, :>=, :<=, :month, :day) }
  end

  it "should accept a partial date and set its vars" do
    expect{@pd = PartialDate.new("05-04")}.to_not raise_error
    @pd.date.should == "05-04"
    expect{@pd = PartialDate.new("2011/05/04")}.to_not raise_error
    @pd.date.should == "05-04"
  end

  context "with different date formats" do
    describe %Q|PartialDate.new("05-04")|  do
      subject {PartialDate.new("05-04")}
      its(:month) {should == 5 }
      its(:day) {should == 4 }
    end

    describe %Q|PartialDate.new("2011/06/24")| do
      subject { PartialDate.new("2011/06/24") }
      its(:month) { should == 6 }
      its(:day) { should == 24 }
    end
  end

  describe "comarpition operator" do 
    let(:target) { PartialDate.new("05-04") }
    let(:day_before) { PartialDate.new("05-03") }
    let(:day_after) { PartialDate.new("05-05") }
    let(:month_after) { PartialDate.new("06-04") }

    specify {(target <=> day_before).should be 1 }
    specify {(month_after <=> target).should be 1 }
    specify {(target <=> month_after).should be -1 }
    specify {(target <=> day_after).should be -1 }
    specify {(target <=> target).should be 0 }
  end

  describe ("compared to " + PartialDate.new("06-04").to_s) do

   subject { PartialDate.new("06-04") }

   it { should be > PartialDate.new("05-04") }
   it { should be > PartialDate.new("06-03") }
   it { should_not be > PartialDate.new("07-01") }
   it { should_not be > PartialDate.new("06-05") }
   it { should be < PartialDate.new("06-05") }
   it { should be < PartialDate.new("07-31") }
   it { should_not be < PartialDate.new("06-04") }
   it { should be >= PartialDate.new("06-04") }
   it { should be >= PartialDate.new("06-03") }
   it { should_not be >= PartialDate.new("06-05") }
   it { should be <= PartialDate.new("06-04") }
   it { should be <= PartialDate.new("06-05") }
   it { should be <= PartialDate.new("06-04") }
  end
end
