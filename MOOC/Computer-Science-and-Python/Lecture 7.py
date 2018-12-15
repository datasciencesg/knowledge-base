### Lecture 7

# L7 Problem 6
def integerDivision(x, a):
    """
    x: a non-negative integer argument
    a: a positive integer argument

    returns: integer, the integer division of x divided by a.
    """
    count = 0
    while x >= a:
        count += 1
        x = x - a
    return count
    
# L7 Problem 7
def rem(x, a):
    """
    x: a non-negative integer argument
    a: a positive integer argument

    returns: integer, the remainder when x is divided by a.
    """
    if x == a:
        return 0
    elif x < a:
        return x
    else:
        return rem(x-a, a)
        
# L7 Problem 8
def f(n):
   """
   n: integer, n >= 0.
   """
   if n == 0:
      return n
   else:
      return n + f(n-1)
        
