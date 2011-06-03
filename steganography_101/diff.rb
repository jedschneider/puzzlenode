module Enumerable
  def frequencies
    self.inject({}) do |m,el|
      m[el] ||= 0
      m[el] += 1
      m
    end
  end
end
firstfile = File.read(ARGV[0])
secondfile = File.read(ARGV[1])

p firstfile.bytes.to_a.zip(secondfile.bytes.to_a).map{|a,b| a - b }.frequencies


