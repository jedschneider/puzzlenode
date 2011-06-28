require 'partial_date_range'
require 'property'

module SeasonalProperty
  include Property

  def nightly_rate(date=nil)
    values, _ = season_for_date(date).values
    values['rate'][/\d+/,0].to_f
  end

  def date_in_season?(date, season)
    values, _ = season.values
    start = values['start']
    finish = values['end']
    range = PartialDateRange.new(start, finish)
    range.includes?(date)
  end

  def season_for_date(date)
    self['seasons'].detect{|season| date_in_season?(date, season)}
  end
end
