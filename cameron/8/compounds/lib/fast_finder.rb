def sub_words(word)
  subs = []
  subs << [word[0..0], word[1..-1]]
  subs << [word[0..1], word[2..-1]]
  subs << [word[0..2], word[3..-1]]
  subs << [word[0..3], word[4..-1]]
  subs << [word[0..4], word[5..-1]]
end



def find_compounds_fast(dict)
  words = IO.read(dict).split("\n")
  dict = {}
  results = []
  possible = {}
  
  words.each do |word|
    length = word.length
    
    # longer words aren't worth considering at all    
    if length > 6
      next
    elsif length < 6
      dict[word.strip.downcase] = true
    else
      word = word.strip.downcase
      sub_words(word).each do |first,second|
        if (dict[first] == true)
          if dict[second] != nil
            results << word
            break
          else 
            possible[word] = first.length - 1
            break
          end
        end
      end
    end
  end
  
  possible.keys.each do |word|
    sub_words(word).each do |first,second|
      if (dict[first] == true)
        if dict[second] != nil
          results << word
        end
      end
    end
  end
  results
end

  
