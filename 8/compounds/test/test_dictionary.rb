require "test/unit"

require "dictionary"

class TestDictionary < Test::Unit::TestCase
  def setup
    @dict = Dictionary.new(%w"cat dog banana")
  end
  
  def test_should_find_word
    assert(@dict.include?('cat'))
  end
  
  def test_should_not_find_word
    assert(!@dict.include?('blahblah'))
  end
  
  def test_should_load_dictionary
    @dict = Dictionary.load('/usr/share/dict/words')
    assert(!@dict.include?('blahblah'))
    assert(@dict.include?('apple'))
  end
  
  def test_should_limit_words_to_six_characters
    @new_dict = @dict.words_of_exact_length(6)
    assert(!@new_dict.include?('cat'))
    assert(@new_dict.include?('banana'))    
  end
end