$: << 'lib'
require 'basic_property'
require 'seasonal_property'
require 'rubygems'
require 'json'

#begin
#  reservation_file = File.open(ARGV.detect{|arg| arg[/.txt$/, 0] })
#  rentals  = JSON.parse(File.read(ARGV.detect{|arg| arg[/.json$/, 0] }))
#rescue
#  raise IOError, 
#  <<-DOC 
#     you need to give me some files
#     like:
#     `ruby hawaii_blue.rb vaction_rentals.json reservations.txt`
#     extensions are sensitive, the names are not
#    DOC
#end

reservation_file = File.read("fixtures/input.txt")
rentals = JSON.parse(File.read("fixtures/vacation_rentals.json"))
out = []

reservation_file.each do |reservation|
  rentals.each do |rental|
    if rental['seasons']
      rental.extend SeasonalProperty
    else
      rental.extend BasicProperty
    end
    out << rental.quote(reservation)
  end
end

open("output.txt", "w") do |file|
  file.write out.join("\n")
end
