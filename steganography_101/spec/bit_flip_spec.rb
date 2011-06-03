require 'rspec'
require 'lib/bit_flip'

include BitFlip

describe "flipping bits" do
  it ":to_zero should flip the last bit to a zero" do
    to_zero(45).should == 44
  end

  it ":to_one should flip the last bit to a one" do
    to_one(44).should == 45
  end
end
