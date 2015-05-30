### Lecture 5
def printMove(fr, to):
    print('move from ' + str(fr) + ' to ' + str(to))
    
def Towers(n, fr, to, spare):
    if n == 1:
        printMove(fr, to)
    else:
        Towers(n - 1, fr, spare, to)
        Towers(1, fr, to, spare)
        Towers(n - 1, spare, to, fr)
  
# L5 Problem 1      
def iterPower(base, exp):
    '''
    base: int or float.
    exp: int >= 0
 
    returns: int or float, base^exp
    '''
    result = 1
    while exp > 0:
        exp -= 1
        result *= base
    return result

def iterPower2(base, exp):
    '''
    base: int or float.
    exp: int >= 0
 
    returns: int or float, base^exp
    '''
    result = 1
    for i in range(exp):
        result *= base
    return result
    
# L5 Problem 2
def recurPower(base, exp):
    '''
    base: int or float.
    exp: int >= 0
 
    returns: int or float, base^exp
    '''
    if exp == 0:
        return float(1)
    else:
        return float(base) * recurPower(base, exp - 1)

# L5 Problem 3
def recurPowerNew(base, exp):
    '''
    base: int or float.
    exp: int >= 0

    returns: int or float; base^exp
    '''
    if exp > 0 and exp % 2 == 0:
        return recurPowerNew(base * base, exp/2)
    elif exp > 0 and exp % 2 == 1:
        return base * recurPowerNew(base, exp - 1)
    elif exp == 0:
        return float(1)
        
# L5 Problem 4
def gcdIter(a, b):
    '''
    a, b: positive integers
    
    returns: a positive integer, the greatest common divisor of a & b.
    '''
    # define a smaller test value; if this test value is not the greatest common
    # denominator, reduce it by one and test again
    smaller = min(a, b)
    while a % smaller != 0 or b % smaller !=0:
        smaller -= 1
    return smaller
    
# L5 Problem 5
def gcdRecur(a, b):
    '''
    a, b: positive integers
    
    returns: a positive integer, the greatest common divisor of a & b.
    '''
    if b == 0:
        return a
    else:
        return gcdRecur(b, a % b)
        
# L5 Problem 6
def lenIter(aStr):
    '''
    aStr: a string
    
    returns: int, the length of aStr
    '''
    length = 0
    for char in aStr:
        length += 1
    return length
    
# L5 Problem 7
def lenRecur(aStr):
    '''
    aStr: a string
    
    returns: int, the length of aStr
    '''
    # Your code here
    length = 0
    if aStr == '':
        return 0
    else:
        return 1 + lenRecur(aStr[ : -1])

# L5 Problem 8
def isIn(char, aStr):
    '''
    char: a single character
    aStr: an alphabetized string
    
    returns: True if char is in aStr; False otherwise
    '''
    # base case: if aStr is empty, we did not find the char
    if aStr == '':
        return False
        
    # base case: if aStr is of length 1, just check if the chars are equal
    elif len(aStr) == 1:
        if aStr == char:
            return True
        else:
            return False
            
    # extract middle char 
              
    mStr = aStr[(len(aStr)/2)]
    
    # check if middle char is equal to test char
    if mStr == char:
        return True
        
    # if middle char is bigger than test char, recursively search the first half
    # string
    elif mStr > char:
        return isIn(char, aStr[:len(aStr)/2])
        
    # otherwise, middle char is smaller than test char, so recursively search the
    # last half of the string
    else:
        return isIn(char, aStr[len(aStr)/2:])
        
# L5 Problem 9
def semordnilapWrapper(str1, str2):
    # A single-length string cannot be semordnilap
    if len(str1) == 1 or len(str2) == 1:
        return False

    # Equal strings cannot be semordnilap
    if str1 == str2:
        return False

    return semordnilap(str1, str2)

def semordnilap(str1, str2):
    '''
    str1: a string
    str2: a string
    
    returns: True if str1 and str2 are semordnilap;
             False otherwise.
    '''
    # Unequal length strings cannot be semordnilap
    if len(str1) != len(str2):
        return False
        
    # index for the first letter of str1
    str1_index = 0
    
    # index for the last letter of str2
    str2_index = 0
    
    # if length of strings are both 1, then the recursive function below has \
    # run it's course, thus true
    if len(str1) == 1 and len(str2) == 1:
        return True
    
    # if the first char of str1 and last char of str2 match, slice those chars 
    # out and check the remaining chars
    elif str1[str1_index] == str2[str2_index - 1]:
        return semordnilap(str1[str1_index + 1:], str2[:str2_index - 1])
    
    
    
    

        
