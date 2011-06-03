begin
  message = ARGV.detect{|arg| arg[/.txt$/, 0] }
  inputfile  = ARGV.detect{|arg| arg[/.bmp$/, 0] }
rescue
    raise IOError, 
    <<-DOC 
       you need to give me some files
       like:
       `ruby sten.rb input.txt input.bmp`
       extensions are sensitive, the names are not
      DOC
  end
outputfile = "output.bmp"

require 'lib/embed_image'

@image = EmbedImage.new(message, inputfile, outputfile)

@image.embed_message
