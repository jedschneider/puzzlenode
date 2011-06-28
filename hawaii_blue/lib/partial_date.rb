require 'date'
class PartialDate
  attr_reader :date
  def initialize(string)
    s = string[/(\d{2}[\/-]\d{2}$)/, 1]
    @date = s.gsub(/\//, '-')
  end

  def <=>(partial_date)
    if month == partial_date.month
      day <=> partial_date.day
    else
      month <=> partial_date.month
    end
  end

  def >(partial_date)
    (self <=> partial_date) == 1
  end

  def <(partial_date)
    (self <=> partial_date) == -1
  end

  def >=(partial_date)
    compare = (self <=> partial_date) 
    compare == 1 or compare == 0 
  end
  
  def <=(partial_date)
    compare = (self <=> partial_date)
    compare == -1 or compare == 0
  end

  def month
    date[/^\d{2}/, 0].to_i
  end

  def day
    date[/\d{2}$/, 0].to_i
  end

  def to_s
    "PartialDate " + @date
  end
end
