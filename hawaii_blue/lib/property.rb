module Property
  def cleaning_fee
    fee = self['cleaning fee']
    fee ? fee[/\d+/,0].to_f : 0.0
  end

  def quote(dates)
    "%s: $%.2f" % [name, total(dates)]
  end

  def name
    self['name']
  end

  def sales_tax
    1.0411416
  end

  # Discussion Point: #rental_cost and #total are defined here
  # but it is dependent on the nightly rate which needs to be defined by the 
  # SeasonalProperty BasicProperty modules, this seems like 
  # violation of OOP but its DRY. I feel like this is the weakest part of my implementation
  def rental_cost(nights)
    nights.map{|night| nightly_rate(night)}.reduce(:+)
  end
  
  def total(dates)
    matches = dates.scan(/(\d{4}\/\d{2}\/\d{2})/)
    range = Date.parse(matches[0][0])...Date.parse(matches[1][0])
    nights = range.map(&:to_s)
    (rental_cost(nights) + cleaning_fee) * sales_tax
  end

  def nightly_rate(date=nil)
    raise NotImplementedError
  end
end
