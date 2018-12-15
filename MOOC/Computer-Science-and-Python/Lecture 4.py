# Lecture 4
def f(x):
    y = 1
    x = x + y
    print ('x = ' + str(x))
    return x

x = 3
y = 2
z = f(x)

# L4 Problem 5
def clip(lo, x, hi):
    '''
    Takes in three numbers and returns a value based on the value of x.
    Returns:
     - lo, when x < lo
     - hi, when x > hi
     - x, otherwise (i.e., x > lo and x < hi)
    '''
    return min(max(lo, x), hi)
 
# L4 Problem 8       
def fourthPower(x):
    '''
    Takes in one number and returns it raised to the fourth power.
    x: int or float.
    '''
    return square(square(x))
    
# L4 Problem 9
def odd(x):
    '''
    x: int or float.

    returns: True if x is odd, False otherwise
    '''
    return bool(x%2)

# L4 Problem 10
def isVowel(char):
    '''
    char: a single letter of any case

    returns: True if char is a vowel and False otherwise.
    '''
    char = char.lower()
    return ( (char == 'a') or \
            (char == 'e') or \
            (char == 'i') or \
            (char == 'o') or \
            (char == 'u') )
            
# L4 Problem 11
def isVowel2(char):
    '''
    char: a single letter of any case

    returns: True if char is a vowel and False otherwise.
    '''
    char = char.lower()
    return char in ('aeiou')
    
# L4 Problem 12
str1 = 'exterminate!'
str2 = 'number one - the larch'
    