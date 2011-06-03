require 'property'

module BasicProperty
  include Property
  def nightly_rate(date=nil)
    self["rate"][/\d+/,0].to_f
  end
end
