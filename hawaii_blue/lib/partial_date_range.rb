require 'partial_date'

class PartialDateRange
  attr_accessor :start_date, :end_date
  def initialize(start, finish)
    @start_date = start.class == PartialDate ? start : PartialDate.new(start)
    @end_date = finish.class == PartialDate ? finish : PartialDate.new(finish)
  end

  def include?(other_date)
    compared = other_date.class == PartialDate ? other_date : PartialDate.new(other_date)
    if start_date < end_date
      start_date <= compared && compared <= end_date
    # overlaps the year end?
    # just see if it is in the bounds of the end and start
    else
      end_date < compared && compared < start_date ? false : true
    end
  end

end
