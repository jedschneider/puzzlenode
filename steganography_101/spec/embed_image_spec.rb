require 'rspec'
require 'lib/embed_image'

describe EmbedImage do
  before(:each) do
    @message = File.read("fixtures/sample_input.txt")
    @image = EmbedImage.new(@message, "fixtures/input.bmp", "output.bmp")
  end

  it "should be able to find the lenght of the data array" do
    @image.end_of_data.should == 262144
  end

  it "should be able to find the start of the data array" do
    @image.data_array_start.should == 1078
  end

  it "should be able to inject the message into the file" do
    @image.embed_message
    File.read("output.bmp").size.should == File.read("fixtures/sample_output.bmp").size
  end

  it "should know about the bytes needed to hide the message" do
    @image.bytes_needed.should == @message.length * 8
  end

  context "IO" do
    before(:each) do
      @out = File.read("fixtures/sample_output.bmp")
    end

    it "should capture the beginning of the bitmap" do
      @image.beginning.should == @out.bytes.to_a[0...1078]
    end

    it "should capture the rest of the file that remains untouched" do
      @image.ending == @out.bytes.to_a[1175..-1]
    end

    it "should capture the area where the the message exists and transform" do
      @image.middle.should == @out.bytes.to_a[1078...1174]
    end

    it "should match the binary" do
      binary = ""
      @image.message.each_char{|c| binary += c.unpack('B8').first}
      result = @out.bytes.to_a[1078...1174].map{|i| i.even? ? 0 : 1}.join("")
      binary.should == result
      result = @image.middle.map{|i| i.even? ? 0 : 1 }.join("")
      binary.should == result
    end
  end

  it "should encode over a total length of bytes" do
    inbytes = [44, 44, 55, 66, 54, 47, 50, 51, 59, 51, 47, 51, 53, 53, 79, 109, 145, 184, 195, 196, 196, 200, 198, 198, 199, 
               193, 192, 191, 183, 178, 159, 120, 105, 110, 119, 131, 135, 142, 155, 159, 165, 163, 167, 178, 174, 182, 180, 
               179, 180, 181, 178, 182, 180, 183, 182, 183, 175, 179, 173, 163, 127, 78, 95, 94, 69, 56, 53, 71, 48, 43, 39, 
               43, 40, 41, 54, 62, 70, 60, 34, 38, 54, 73, 43, 47, 75, 71, 63, 85, 56, 64, 62, 72, 70, 57, 70, 72]
    outbytes = [44, 45, 54, 66, 55, 46, 50, 50, 58, 51, 47, 50, 52, 53, 78, 109, 144, 185, 195, 196, 197, 201, 198, 198, 198, 
                193, 193, 190, 183, 179, 158, 120, 104, 111, 119, 130, 135, 143, 155, 159, 164, 162, 167, 178, 174, 182, 180, 
                178, 180, 181, 178, 183, 180, 183, 183, 183, 174, 179, 173, 162, 127, 79, 95, 95, 68, 57, 53, 71, 48, 42, 39, 
                42, 40, 41, 55, 62, 71, 61, 34, 38, 54, 73, 43, 46, 74, 71, 62, 84, 56, 64, 62, 72, 71, 56, 71, 72]
    @image.add_message_to(inbytes).should == outbytes
  end

  it "should be able to know when to flip a byte" do
    @image.process([0,44]).should == 44
    @image.process([1,44]).should == 45
    @image.process([0,55]).should == 54
  end

  it "should apply a character over a set of 8 bytes" do
    inbytes =  [44, 44, 55, 66, 54, 47, 50, 51] 
    outbytes = [44, 45, 54, 66, 55, 46, 50, 50]
    @image.apply_character("H", inbytes).should == outbytes
  end
end
