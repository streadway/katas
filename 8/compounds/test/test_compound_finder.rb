require "test/unit"

require "compound_finder"

class TestCompoundFinderTest < Test::Unit::TestCase
  def setup
    @dictionary = Dictionary.new(%w{albums purple al bums})
    @compounds = CompoundFinder.new(@dictionary)
  end
  
  def test_should_initialize_simple_list
    assert_equal(1, @compounds.list.length)
    assert(@compounds.list.include?('albums'))
    assert(!@compounds.list.include?('purple'))
  end
  
  def test_subword_finder
    subs = @compounds.sub_words('purple')
    assert_equal([['p', 'urple'],['pu', 'rple'],['pur', 'ple'],['purp', 'le'],['purpl', 'e']], subs)
  end
  
  def test_can_be_split
    assert(@compounds.can_be_split?('albums'))
    # assert(!@compounds.can_be_split?('purple'))    
  end
end


