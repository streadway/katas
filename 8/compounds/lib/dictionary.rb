class Dictionary
  include Enumerable
  
  def initialize(words)
    @words = {}
    words.each do |word|
      @words[word.strip.downcase] = true;
    end
  end
  
  def self.load(filename)
    Dictionary.new(IO.read(filename).split)
  end
  
  def include?(word)
    @words[word] != nil
  end
  
  def words_of_exact_length(length)
    Dictionary.new(@words.keys.select{|w| w.length == length})
  end
  
  def each(&block)
    @words.keys.each &block
  end
  
end