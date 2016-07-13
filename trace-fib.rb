require "pry"

binding.pry
def fib(n)
  f = nil
  f0 = f1 = 1
  while n > 1
    n -= 1
    f = f0 + f1
    f0 = f1
    f1 = f
  end

  f
end

n = 9
while n > 0
  puts "fib(#{n})=#{fib(n)}"
  n -= 1
end
