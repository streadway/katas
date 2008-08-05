class FindConcatenated
  attr_accessor :wordlist, :size_hash, :result
  
  def initialize(wordfile)
    @wordlist = IO.readlines(wordfile).each{|w| w.gsub!("\n", "")}
    @result = ""
  end
  
  #remove words larger than the length of the concatenation
  def remove_large_words
    @wordlist.delete_if{|word| word.length > 6}
  end
  
  #create a hash with each word length as a key
  def group_by_length
    @size_hash = {}
    @wordlist.each do |word|
      @size_hash[word.length] ? @size_hash[word.length] << word : @size_hash[word.length] = [word]
    end
  end
  
  def find
    (1..5).each do |n|
      @size_hash[n].each do |a|
        @size_hash[6-n].each do |b|
          if @size_hash[6].include?(a + b)
            @result << "#{a} + #{b} => #{a+b}\n"
          end
        end if @size_hash[6-n]
      end if @size_hash[n]
    end
  end
  
  def run
    remove_large_words
    group_by_length
    find
    @result
  end
end