require 'lib/bit_flip'

class EmbedImage
  include BitFlip
  attr_accessor :message, :infile, :outfile_name

  def initialize(message, infile, outfile)
    @message = message
    @infile = File.read(infile)
    @outfile_name = outfile
  end

  def embed_message
    out = beginning + middle + ending
    open(outfile_name, "wb") do |f|
      out.each{|byte| f.write byte.chr}
    end
  end

  def beginning
    infile.bytes.to_a[0...data_array_start]
  end 

  def middle
    message_bytes = infile.bytes.to_a[data_array_start...(data_array_start + bytes_needed)]
    add_message_to(message_bytes)
  end

  def ending
    the_split = data_array_start + bytes_needed
    infile.bytes.to_a[the_split..-1].map{|n| to_zero(n)}
  end

  def build
    full = beginning + middle + ending
  end

  def bytes_needed
    message.length * 8
  end

  def data_array_start
    location = @infile.bytes.to_a[10...14]
    get_offset(location)
  end

  def end_of_data
    location = @infile.bytes.to_a[34...38]
    get_offset(location)
  end

  def get_offset(location)
    exponents = [0,1,2,3]
    starting_byte = location.zip(exponents).map do |pair|
      value, exponent = pair
      (256 ** exponent) * value
    end
    starting_byte.reduce(:+)
  end

  def process(array)
    bit, target = array
    bit.zero? ? to_zero(target) : to_one(target)
  end

  def apply_character(char, my_array)
    ascii, _  = char.unpack('B8') # => unpack returns an array
    pairs = []
    ascii.scan(/\w/) {|c| pairs << c.to_i}
    pairs.zip(my_array).map{|pair| process(pair) }
  end

  def add_message_to(bytes)
    start = 0
    out = []
    message.each_char do |c|
      out << apply_character(c, bytes[start...(start + 8)])
      start += 8
    end
    out.flatten
  end
end
