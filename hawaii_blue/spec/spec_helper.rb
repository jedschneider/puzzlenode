$: << '../lib'
require 'rspec'
require 'seasonal_property'
require 'basic_property'

shared_examples_for "a property" do
  subject { Hash.new().extend described_class}
  it {should respond_to(:name, :sales_tax, :cleaning_fee, :quote, :rental_cost, 
                        :nightly_rate, :total, :rental_cost) }
  it { should respond_to(:nightly_rate).with(1).argument }
  it { should respond_to(:nightly_rate).with(0).arguments }
end
