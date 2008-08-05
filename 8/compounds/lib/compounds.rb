require 'dictionary'
require 'compound_finder'
require 'kz_timer'
require 'fast_finder'

class Compounds 
  VERSION = '1.0.0'
end


timer = SimpleTimer.new
dict_file = ARGV[0]

timer.run do
  dict = Dictionary.load(dict_file)
  finder = CompoundFinder.new(dict)
  list = finder.list

  # puts list.join("\n")
  puts "Readable"
  puts "-------"
  puts "Total: #{list.length}"
end


timer.run do
  list = find_compounds_fast(ARGV[0])
  puts "Fast"
  puts "-------"
  puts "Total: #{list.length}"  
end




