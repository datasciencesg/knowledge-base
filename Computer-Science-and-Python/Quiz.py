### Quiz

# Problem 4
def myLog(x, b):
    '''
    x: a positive integer
    b: a positive integer; b >= 2

    returns: log_b(x), or, the logarithm of x relative to a base b.
    '''    
    # initialize result and power
    power = 1
    result = 1
    
    # while result is less than x (i.e., target)
    while result < x:
    
        # multiply result by b
        result *= b
        power += 1
        
        # if result after multiplication > x, return the power from 2 loops before
        if result > x:
            return power - 2
        
        # elif result after multiplication == x, return power from previous loop
        if result == x:
            return power - 1
        
        # elif result after multiplication < x, continue with while loop
        if result < x:
            pass
    
# Problem 5
def laceStrings(s1, s2):
    """
    s1 and s2 are strings.

    Returns a new str with elements of s1 and s2 interlaced,
    beginning with s1. If strings are not of same length, 
    then the extra elements should appear at the end.
    """
    # initialize the length of the shorter string
    length = min(len(s1), len(s2))
    
    # initialize the longer string
    longer_string = max(s1, s2, key = len)
    
    # initialize result string
    result = ''
    
    # for the length of the shorter string
    for i in range(length):
    
        # add element i from s1 to the result string
        result += s1[i]
        
        # add element i from s2 to the result string
        result += s2[i]
    
    # add any leftover chars from s1 or s2 to the result string
    result += longer_string[length: ]
    
    # return result string
    return result

# Problem 6  
def laceStringsRecur(s1, s2):

    """
    s1 and s2 are strings.

    Returns a new str with elements of s1 and s2 interlaced,
    beginning with s1. If strings are not of same length, 
    then the extra elements should appear at the end.
    """
    def helpLaceStrings(s1, s2, out):
        if s1 == '':
            #PLACE A LINE OF CODE HERE
            return out+s2
        if s2 == '':
            #PLACE A LINE OF CODE HERE
            return out+s1
        else:
            #PLACE A LINE OF CODE HERE
            return helpLaceStrings(s1[1:], s2[1:], out+s1[0]+s2[0])
    return helpLaceStrings(s1, s2, '')
    
# Problem 7
def McNuggets(n):
    """
    n is an int

    Returns True if some integer combination of 6, 9 and 20 equals n
    Otherwise returns False.
    The function is as such, 6a + 9b + 20c = n
    """
    # if number is bigger than 45, there will be a combination; thus return True
    if n > 45:
        return True
    
    # if number is less than 5, return False
    if n < 6:
        return False
        
    # if number can be divided by 6 or 9 or 20 directly, return True
    if (n % 6 == 0) or (n % 9 == 0) or (n % 20 == 0):
        return True
    
    # initialize ranges of highest multiple for each package size
    a = range(n/6 + 1)
    b = range(n/9 + 1)
    c = range(n/20 + 1)
    
    # for each possible combination, check if 6*a + 9*b + 20*c == n.  If so, 
    # return True
    for i in a:
        for j in b:
            for k in c:
                if 6*i + 9*j + 20*k == n:
                    return True
    
    # if the loops above run but no True value, return False
    return False


def McNuggets(n): 
    ret = False 

    if (n < 1): 
        return False; 
    if ((n % 6 == 0)or(n % 9 == 0)or(n % 20 == 0)): 
        return True 
    if (ret == False and n > 20): 
        ret = McNuggets(n - 20) 
    if (ret == False and n > 9): 
        ret = McNuggets(n - 9) 
    if (ret == False and n > 6): 
        ret = McNuggets(n - 6) 
    return ret

def McNuggets(n):
    for a in range(n/6+1):
        for b in range(n/9+1):
            for c in range(n/20+1):
                if 6*a+9*b+20*c == n:
                    return True
    return False


# Problem 8-1
def fixedPoint(f, epsilon):
    """
    f: a function of one argument that returns a float
    epsilon: a small float
  
    returns the best guess when that guess is less than epsilon 
    away from f(guess) or after 100 trials, whichever comes first.
    """
    guess = 1.0
    for i in range(100):
        if abs(f(guess) - guess) < epsilon:
            return guess
        else:
            guess = f(guess)
    return guess

# Problem 8-2
def sqrt(a):
    def tryit(x):
        return 0.5 * (a/x + x)
    return fixedPoint(tryit, 0.0001)
    
# Problem 8-3
def babylon(a):
    def test(x):
        return 0.5 * ((a / x) + x)
    return test
    
def sqrt(a):
    return fixedPoint(babylon(a), 0.0001)