class StringSplitter

  def left(text)
    text.slice(0..(midpoint(text)))
  end

  def right(text)
    text.slice((midpoint(text)+1)..-1)
  end

  def midpoint(text)
    text.rindex(' ', text.length/2)
  end

  def image_search_text(text)
    text = no_hashes(text)
    text = no_ats(text)
    ##text = add_new_orleans(text)
  end

  def add_new_orleans(text)
    if text.scan(/new orleans|nola/i).empty?
      "'New Orleans' #{text}" 
    else
      text
    end
  end

  def no_hashes(text)
    text.gsub(/#[^s]+/,'')
  end

  def no_ats(text)
    text.gsub(/@[^s]+/,'')
  end
end

if __FILE__ == $0
  mytext = "This text needs to split on a space boundary #bearcamp /cc @bearcamp"
  splitter = StringSplitter.new()
  puts splitter.left(mytext)
  puts splitter.right(mytext)
  puts splitter.no_hashes(mytext)
  puts splitter.add_new_orleans(mytext)
  puts splitter.no_ats(mytext)
end
