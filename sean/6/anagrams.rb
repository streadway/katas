File.read('wordlist.txt').inject({}) do |hash, word| 
	word.strip!.downcase!
	(hash[word.split('').sort.join] ||= []) << word
	hash
end.each do |k,anagrams|
	puts anagrams.join(' ') if anagrams.size > 1
end
