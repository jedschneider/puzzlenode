require 'spec_helper'

describe SeasonalProperty do
  let(:property) do
    {"name"=>"Fern Grove Lodge", "cleaning fee"=>"$98", "seasons"=>[
      {"one"=>{"rate"=>"$137", "end"=>"05-13", "start"=>"05-06"}}, 
      {"two"=>{"rate"=>"$220", "end"=>"04-30", "start"=>"05-14"}}]}.extend SeasonalProperty
  end
  
  it_behaves_like "a property"

  it "should define its nightly rate" do
    property.nightly_rate("2011-05-07").should == 137.0
    property.nightly_rate("2011-05-15").should == 220.0
    property.nightly_rate("2012-01-31").should == 220.0
  end

  it "should be able to find the season that included the requested date" do
    first = %w(2011/05/06 2011/05/13 2011/05/07)
    last = %w(2011/05/15 2011/12/31 2012/01/01 2012/04/29 2011/05/14 2012/04/30)
    
    first.each{|date| property.season_for_date(date).should == property['seasons'].first }
    last.each{|date| property.season_for_date(date).should == property['seasons'].last }
  end 

  it "should return nil if there is no season associated" do
    property.season_for_date("2012-05-01").should == nil
  end

  it "should be able to determine if a date lies within the season" do
    date = "2011/05/07"
    property.date_in_season?(date, property['seasons'].first).should == true
    property.date_in_season?(date, property['seasons'].last).should == false
  end

end
