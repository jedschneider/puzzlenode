module Property
  def cleaning_fee
    fee = self['cleaning fee']
    fee ? fee[/\d+/,0].to_f : 0.0
  end

  def quote(dates)
    sprintf("%s: $%.2f", name, total(dates))
  end

  def total(dates)
    matches = dates.scan(/(\d{4}\/\d{2}\/\d{2})/)
    range = Date.parse(matches[0][0])...Date.parse(matches[1][0])
    nights = range.map(&:to_s)
    (rental_cost(nights) + cleaning_fee) * sales_tax
  end

  def name
    self['name']
  end

  def sales_tax
    1.0411416
  end

  def rental_cost(nights)
    nights.map{|night| nightly_rate(night)}.reduce(:+)
  end

  def nightly_rate(date)
    raise NotImplementedError
  end
end
