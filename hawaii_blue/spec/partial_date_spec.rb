require 'spec_helper'

describe PartialDate do
  it "should accept a partial date and set its vars" do
    expect{@pd = PartialDate.new("05-04")}.to_not raise_error
    @pd.date.should == "05-04"
    expect{@pd = PartialDate.new("2011/05/04")}.to_not raise_error
    @pd.date.should == "05-04"
  end

   context "when comparing two partial dates" do
     it "should respond to the comparison operator" do
       expect { PartialDate.new("05-04").send(:<=>, PartialDate.new("05-05") )}.to_not raise_error
     end

     it "should know its month" do
       PartialDate.new("05-04").month.should == 5
       PartialDate.new("2011/05/04").month.should == 5
     end

     it "should know its day" do
       PartialDate.new("05-04").day.should == 4
       PartialDate.new("2011/05/04").day.should == 4
     end

     it "should return 1 when it has a date later than the compared date" do
       (PartialDate.new("05-04") <=> PartialDate.new("04-04")).should == 1
       (PartialDate.new("05-04") <=> PartialDate.new("05-03")).should == 1
     end

     it "should return -1 when it has a date earlier than the compared date" do
       (PartialDate.new("05-04") <=> PartialDate.new("06-04")).should == -1
       (PartialDate.new("05-04") <=> PartialDate.new("05-05")).should == -1
     end

     it "should retun 0 if the partial dates are equal" do
       (PartialDate.new("05-04") <=> PartialDate.new("05-04")).should == 0
     end

     it "should know that it is greater than another partial date" do
       (PartialDate.new("06-04") > PartialDate.new("05-04")).should be true
       (PartialDate.new("05-05") > PartialDate.new("05-04")).should be true
       (PartialDate.new("04-05") > PartialDate.new("05-04")).should be false
       (PartialDate.new("05-05") > PartialDate.new("05-05")).should be false
     end

     it "should know that it is less than another partial date" do
       (PartialDate.new("05-04") < PartialDate.new("06-04")).should be true
       (PartialDate.new("05-05") < PartialDate.new("05-06")).should be true
     end

     it "should know if it is greater than or equal to another date" do
       (PartialDate.new("05-04") >= PartialDate.new("05-04")).should == true
       (PartialDate.new("05-04") >= PartialDate.new("05-03")).should == true
       (PartialDate.new("05-04") >= PartialDate.new("05-05")).should == false
     end

     it "should know if it is less than or equal to anther date" do
       (PartialDate.new("05-14") <= PartialDate.new("05-14")).should == true
       (PartialDate.new("05-04") <= PartialDate.new("05-04")).should == true
       (PartialDate.new("05-04") <= PartialDate.new("05-05")).should == true
       (PartialDate.new("05-04") <= PartialDate.new("05-03")).should == false
     end
  end
end
