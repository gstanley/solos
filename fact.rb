def fact(n, acc = 1)
  return acc if n <= 1
  fact(n - 1, n * acc)
end
