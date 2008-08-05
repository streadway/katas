class FindConcatenated
  attr_accessor :wordlist, :size_hash, :result, :six_letter_words
  
  def initialize(wordfile)
    @wordlist = IO.readlines(wordfile).each{|w| w.gsub!("\n", "")}
    @result = ""
  end
  
  #remove words larger than the length of the concatenation
  def remove_large_words(size=6)
    @wordlist.delete_if{|word| word.length > size}
  end

  #create a hash with each word length as a key
  def group_by_length
    @size_hash = {}
    @wordlist.each do |word|
      @size_hash[word.length] ? @size_hash[word.length] << word : @size_hash[word.length] = [word]
    end
  end
  
  #create a hash of all six letter words that we can check against
  def hash_six_letter_words
    @six_letter_words = {}
    @size_hash[6].each do |word|
      @six_letter_words[word] = true
    end
  end
  
  def find
    (1..size-1).each do |n|
      @size_hash[n].each do |a|
        @size_hash[6-n].each do |b|
          if @six_letter_words[(a + b)]
            @result << "#{a} + #{b} => #{a+b}\n"
          end
        end
      end if @size_hash[n]
    end
  end
  
  def run
    remove_large_words
    group_by_length
    hash_six_letter_words
    find
    @result
  end
end