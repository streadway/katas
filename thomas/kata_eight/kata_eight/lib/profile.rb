require 'benchmark'
include Benchmark
  
  @wordlist = IO.readlines(ARGV[0]).each{|w| w.gsub!("\n", "")}
  @result   = ""
  
  #remove words larger than the length of the concatenation
  @wordlist.delete_if{|word| word.length > 6}

  #create a hash with each word length as a key
  @size_hash = {}
  @wordlist.each do |word|
    @size_hash[word.length] ? @size_hash[word.length] << word : @size_hash[word.length] = [word]
  end
  
  bm(5) do |test|
    test.report("one:") do
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
    
    test.report("two:") do
      @six_letter_words = {}
      @size_hash[6].each do |word|
        fl = word[0,1]
        @six_letter_words[fl] ? @six_letter_words[fl] << word : @six_letter_words[fl] = [word]
      end
      
      (1..5).each do |n|
        @size_hash[n].each do |a|
          @size_hash[6-n].each do |b|
            if @six_letter_words[a[0,1]].include?(a + b)
              @result << "#{a} + #{b} => #{a+b}\n"
            end
          end if @size_hash[6-n]
        end if @size_hash[n]
      end 
    end
    
    test.report("three:") do
      @six_letter_words = ""
      @size_hash[6].each do |word|
        @six_letter_words << " #{word} "
      end   
      
      (1..5).each do |n|
        @size_hash[n].each do |a|
          @size_hash[6-n].each do |b|
            if @six_letter_words.match(/ #{a+b} /)
              @result << "#{a} + #{b} => #{a+b}\n"
            end
          end if @size_hash[6-n]
        end if @size_hash[n]
      end         
    end
    
    test.report("four:") do
      @size_hash[6].each do |word|
        (1..5).each do |n|
          @size_hash[n].each do |a|
            @size_hash[6-n].each do |b|
              if word  == a + b
                @result << "#{a} + #{b} => #{word}\n"
              end
            end if @size_hash[6-n]
          end if @size_hash[n]        
        end
      end
    end
  end
  
  
#  thomas-pomfrets-macbook-2:kata thomas$ ruby lib/profile.rb 'data/short.txt' 
#             user     system      total        real
#  one:   0.000000   0.000000   0.000000 (  0.001912)
#  two:   0.010000   0.000000   0.010000 (  0.001491)
#  three:  0.000000   0.000000   0.000000 (  0.001189)
#  thomas-pomfrets-macbook-2:kata thomas$ ruby lib/profile.rb 'data/wordlist.txt' 
#             user     system      total        real
#  one: 407.900000  13.670000 421.570000 (465.533939)
#  two:  15.780000   0.510000  16.290000 ( 17.254235)
#  three: 37.710000   1.200000  38.910000 ( 41.475104)
  
  