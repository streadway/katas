#!/usr/bin/env ruby 

# ~5 min labor
def readable
  words      = File.read('wordlist.txt').map { |word| word.strip.downcase }
  candidates = words.select { |word| word.size == 6 }
  parts      = words.select { |word| word.size < 6 }
  matches    = []

  candidates.each do |candidate|
    (2..4).each do |pivot|
      first, last = candidate[0...pivot], candidate[pivot..-1]
      if parts.include?(first) && parts.include?(last)
        matches << [first, last, candidate]
      end
    end
  end

  matches
end

# ~10 min labor
def fast
  lookup, candidates, matches = {}, [], []

  File.read('wordlist.txt').each do |word| 
    word.strip!

    if word.size == 6
      candidates << word.downcase 
    elsif word.size < 6
      lookup[word.downcase] = true
    end
  end

  candidates.each do |candidate|
    (2..4).each do |pivot|
      first, last = candidate[0...pivot], candidate[pivot..-1]
      if lookup[first] && lookup[last]
        matches << [first, last, candidate]
      end
    end
  end

  matches
end


# ~30 min
# incorrect - late night attempt, poor assumptions about how to build the graph
# will give positive result on mismatched termination
def faster
  lookup, candidates, matches = {}, [], []

  File.read('wordlist.txt').each do |word| 
    word.strip!.downcase!

    if word.size == 6
      candidates << word
    elsif word.size < 6
      node = lookup
      (0...word.size).each do |i|
        node = (node[word[i]] ||= {})
        if i == word.size - 1
          node[:found] = true
        end
      end
    end
  end

  def _find(tree, start, word)
    node = tree
    ends = []
    (start...word.size).each do |i|
      node = node[word[i]]
      break if node.nil?
      ends << i if node[:found]
    end
    return ends
  end

  candidates.each do |word|
    _find(lookup, 0, word).each do |start|
      if _find(lookup, start+1, word) == [ word.size - 1 ]
        matches << [ word[0...start], word[start..-1], word ]
      end
    end
  end

  return matches
end

# ~1 min - trying an idea out
def fast_attempt_but_reaches_limit_of_regexp
  parts, candidates, matches = [], [], []

  File.read('wordlist.txt').each do |word| 
    word.strip!

    if word.size == 6
      candidates << word
    elsif word.size < 6
      parts << word
    end
  end

  matcher = Regexp.new("(#{parts.join('|')})(#{parts.join('|')})", "i")

  candidates.grep(matcher).each do |candidate|
    matches << [ $1, $2, candidate ]
  end

  matches
end

# Different API returning [ word, [part1, part2, .. partN] ]
# ~ 30 min - complete with duplicate functionality
# ~ 45 min - still working on getting 7/3
# ~ 1h - epic fail
def extensible(words = 'wordlist.txt', candidate_length = 6, composition_count = 2)
  matches = []
  words = case words
          when Array; words
          when String; File.read(words)
          else raise RuntimeError.new("Unknown parameter #{words.inspect}")
          end.map { |word| word.strip.downcase }

  candidates = words.select { |word| word.size == candidate_length }
  parts      = words.select { |word| word.size < candidate_length }

  # need all the words this word is composed of in order
  permutate = lambda do |word, remaining_compositions|
    return [word] unless remaining_compositions > 1
    splits = []

    (0...remaining_compositions).map do |remaining|
      (1..(word.size-1)).map do |pivot|
        splits << word[0...pivot] 
      end
    end
  end

  candidates.each do |candidate|
    permutate.call(candidate, composition_count).each do |pairs| 
      if pairs.all? { |part| parts.include?(part) }
        matches << [ candidate, pairs ]
      end
    end
  end

  matches
end


# Run the objectives

require 'benchmark'

def verify(expected_size = 1536)
  $stdout.write(
    if yield.size == expected_size
      "           "
    else
      "(incorrect)"
    end
  )
end

Benchmark.benchmark(" " * 22 + Benchmark::CAPTION, 0, Benchmark::FMTSTR) do |x|
  x.report("Readable:  ") { verify { readable } }
  x.report("Extensible:") { verify { extensible } }
  x.report("Fast:      ") { verify { fast } }
  x.report("Faster:    ") { verify { faster } }
end
