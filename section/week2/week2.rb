def fib(n)
    a = 1
    b = 1
    i = 1
    while (i < n)
        yield a
        t = b
        b = a + b
        a = t
        i += 1
    end
end