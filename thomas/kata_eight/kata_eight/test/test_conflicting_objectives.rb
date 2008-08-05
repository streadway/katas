require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'
require File.dirname(__FILE__) + '/../lib/find_concatenated.rb'

class FindConcatenatedTest < Test::Unit::TestCase
  def setup
    flexmock(IO).should_receive(:readlines).and_return(['abandoning', 'tail', 'or', 'tailor', 'we', 'aver', 'weaver'])
  end
  
  def test_word_array_is_created
    concatenated = FindConcatenated.new('test.txt')
    assert_equal ['abandoning', 'tail', 'or', 'tailor', 'we', 'aver', 'weaver'], concatenated.wordlist
  end
  
  def test_big_words_are_removed
    concatenated = FindConcatenated.new('test.txt')
    assert_equal ['tail', 'or', 'tailor', 'we', 'aver', 'weaver'], concatenated.remove_large_words
  end
  
  def test_grouping_by_length
    concatenated = FindConcatenated.new('test.txt')
    concatenated.group_by_length
    assert_equal concatenated.size_hash, {2 => ['or', 'we'], 4 => ['tail', 'aver'], 6 => ['tailor', 'weaver'], 10 => ['abandoning']}
  end
  
  def test_find_concatenated
    concatenated = FindConcatenated.new('test.txt')
    assert_equal "we + aver => weaver\ntail + or => tailor\n", concatenated.run
  end
end