def series(method, n)
  case
  when method == 'fibonacci' then fibonacci(n)
  when method == 'lucas'     then lucas(n)
  when method == 'summed'    then fibonacci(n) + lucas(n)
  end
end

def fibonacci(n)
  return n if n <= 1
  fibonacci(n - 1) + fibonacci(n - 2)
end

def lucas(n)
  return 2 if n == 1
  return 1 if n == 2
  lucas(n - 1) + lucas(n - 2)
end
