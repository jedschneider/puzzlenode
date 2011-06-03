# Hawaii Blue
My solution to the Hawaii Blue puzzler at ["Puzzle Node"](http://puzzlenode.com/puzzles/13)

The basic premise is that there is a list of properties in json format (examples in the fixtures folder) and you must present a reservation quote for each property in a given reservation period. Rates may vary in a variable number of seasons and there may or may not be a cleaning fee associated with the property. 

* * * 

## Running the code

You need the json-pure gem for parsing the JSON

    gem install json-pure

In order to run the specs you need RSpec 2.x

    gem install rspec

Otherwise its all base ruby libraries with no fancy 1.9 syntax. 

Expected use is:

    ruby hawaii_blue.rb vacation_rentals.json reservations.txt

The extensions are important, but the names or locations of the files can be whatever. The resulting file is called `output.txt` and will be in the root of the project directory.

* * * 

## Polymorphic Hashes Make Me Happy

Inspired by a talk on the [Data-Context-Interaction Design Pattern](http://en.oreilly.com/rails2011/public/schedule/detail/19424) at RailsConf, I wanted to think about more role based interaction. My solution was to extend the basic hash object  (returned by the json parsing engine) with functionality specific to the role of the property. The result is a 'role based' hash.

    if property['seasons']
      property.extend SeasonalProperty
    else
      property.extend BasicProperty
    end
    
    property.quote("2011/05/05 - 2011/05/20") # => Jed's Villa: $3456.45

Both modules use another module `Property` where the shared functionality for both roles is found. The important specs: 

    Property
      should raise an implenetation error when no nightly_rate method is found
      should format the quote accordingly
      should report the total cost for a requested reservation period
      should know about its name
      should return its cleaning fee
      should know about sales tax
  
Since the separate roles take care of providing the Property with the relevant `nightly_rate` method, there is very little unique functionality needed.

    SeasonalProperty
      should define its nightly rate
      should be able to find the season that included the requested date

    BasicProperty
      should define the nightly rate

The same concept can be applied with a class oriented solution, with similar clarity and intent, _eg:_

    class SeasonalProperty < Property ; #stuff ; end
    class BasicProperty < Property ; #stuff ; end
    
    if property['seasons']
      @property = SeasonalProperty.new(property)
    else
      @property = SeasonalProperty.new(property)
    end
   
    @property.quote("2011/05/05 - 2011/05/20")
    
However, I thought this was an interesting situation to play with the idea of roles on objects and reduce the abstraction and reliance on classes just for the formality of having classes. In the above example I don't think the class abstraction adds any value to the solution. Since there is never an intent in this exercise to do comparison of two similar class objects, using a base object and just adding role specific functionality to it is enough to get to the eventual goal: a fancy `to_s` call.

## Challenges

The partial date was a bit of a challenge. I really wanted to be able to ask for a nightly_rate for a particular rental, this would allow the API to feel very clean and also reduce the necessary code to determine which season I was in for range of dates in total.

    property.nightly_rate(date)
    
And then chain these nightly rates together to get a total:

    dates.map{|date| property.nightly_rate(date)}.reduce(:+)

I also felt that without implementing the nightly_rate this way the functionality determining the nightly rate would need to know too much about the start and end of the seasons and the start and end of reservation period. I felt like this violated SRP. 

It is simple to create comparisons of partial dates (look at `partial_date.rb`), the specs:

    PartialDate
      should accept a partial date and set its vars
      when comparing two partial dates
        should respond to the comparison operator
        should know its month
        should know its day
        should return 1 when it has a date later than the compared date
        should return -1 when it has a date earlier than the compared date
        should retun 0 if the partial dates are equal
        should know that it is greater than another partial date
        should know that it is less than another partial date
        should know if it is greater than or equal to another date
        should know if it is less than or equal to anther date

So the challenge was creating a way to know about when the season overlapped the year-end mark, eg, the start date was after the end date `:start => "5-15", :end => '4-30'`

My code for that is in `PartialDateRange#include?` Basically, I just swap the start and end dates under the above condition so instead of having to worry about the year end issue, I just look to see if it is inside the narrower range. The specs:

    PartialDateRange
      should know a date falls within the range
      should accept strings and ParitalDate class objects interchangably as parameters
      should be able to know when a date wraps a year
      
I'm looking forward to hearing what people think of this little solution.



  
