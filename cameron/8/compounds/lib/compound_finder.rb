class CompoundFinder
  attr_reader :dictionary
  
  def initialize(dictionary)
    @dictionary = dictionary
  end
  
  def list
    candidates = dictionary.words_of_exact_length(6)
    candidates.select{|c| can_be_split?(c) }
  end

  def sub_words(word)
    subs = []
    subs << [word[0..0], word[1..-1]]
    subs << [word[0..1], word[2..-1]]
    subs << [word[0..2], word[3..-1]]
    subs << [word[0..3], word[4..-1]]
    subs << [word[0..4], word[5..-1]]
  end
  
  def can_be_split?(word)
    sub_words(word).detect {|first, second| dictionary.include?(first) && dictionary.include?(second) } != nil
  end
  
end