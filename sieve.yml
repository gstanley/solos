- def:
    lang: ruby
    file: sieve.rb
- src: # sieve of Eratosthenes
- src: max = Integer(ARGV.shift || 100)
  deps:
- src: sieve = []
- src: for i in 2 .. max
- src:   sieve[i] = i
- src: end
- src: 
- src: for i in 2 .. Math.sqrt(max)
- src:   next unless sieve[i]
- src:   (i*i).step(max, i) do |j|
- src:     sieve[j] = nil
- src:   end
- src: end
- src: puts sieve.compact.join(", ")
