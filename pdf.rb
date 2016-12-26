require 'pdf/reader'

class TextParse
  attr_accessor :pdf, :paragraphs

  def initialize(file)
    @pdf = PDF::Reader.new(file)
    @paragraphs = make_paragraphs
  end

  def pdf_string
    str = ""
    @pdf.pages.each do |page|
      str << page.text
    end
    str.gsub("\n\n\n", "\n\n")
  end

  def make_paragraphs
    @paragraphs = []
    pdf_string.split(/\.\n\n/).each do |para|
      @paragraphs << Paragraph.new(para)
    end
    @paragraphs
  end

  def display
    @paragraphs.each do |paragraph|
      puts paragraph.clean_string
      puts
    end
  end
end

class Paragraph
  attr_accessor :string

  def initialize(raw_string)
    @paragraph_string = raw_string
  end

  def clean_string
    @paragraph_string.gsub!("\n\n", "\n")
    @paragraph_string.gsub!("\n", " ")
    @paragraph_string << "."
  end
end





file = "pdf/the_garbage_collector.pdf"

reader = TextParse.new(file)


reader.display

