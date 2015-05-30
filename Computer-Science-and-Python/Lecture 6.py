### Lecture 6

# L6 Problem 2
def oddTuples(aTup):
    '''
    aTup: a tuple
    
    returns: tuple, every other element of aTup. 
    '''
    result = ()
    for i in range(0, len(aTup), 2):
        odd_tup = (aTup[i], )
        result += odd_tup
    return result
    
# L6 Problem 7
def applyToEach(L, f):
    for i in range(len(L)):
        L[i] = f(L[i])
        
testList = [1, -4, 8, -9]

# sample
def timesFive(a):
    return a * 5
     
applyToEach(testList, timesFive)

# Qn 1
def absolut(a):
    return abs(a)
        
applyToEach(testList, absolut)
print testList

# Qn 2
def plus_one(a):
    return a + 1
    
applyToEach(testList, plus_one)
print testList

# Qn 3
def square(a):
    return a * a
    
applyToEach(testList, square)

# L6 Problem 8
def applyEachTo(L, x):
    result = []
    for i in range(len(L)):
        result.append(L[i](x))
    return result
    
def square(a):
    return a*a

def halve(a):
    return a/2

def inc(a):
    return a+1
    
applyEachTo([inc, square, halve, abs], -3)

# L6 Problem 11
animals = { 'a': ['aardvark'], 'b': ['baboon'], 'c': ['coati']}

animals['d'] = ['donkey']
animals['d'].append('dog')
animals['d'].append('dingo')

def howMany(aDict):
    '''
    aDict: A dictionary, where all the values are lists.

    returns: int, how many values are in the dictionary.
    '''
    result = 0
    for a in aDict:
        result += len(aDict[a])
    return result
    
howMany(animals)
        
# L6 Problem 12
def biggest(aDict):
    '''
    aDict: A dictionary, where all the values are lists.

    returns: The key with the largest number of values associated with it
    '''
    result = None
    biggest_val = 0
    for key in aDict.keys():
        if len(aDict[key]) >= biggest_val:
            result = key
            biggest_val = len(aDict[key])
    return result
    
### Problem Set 3
# Radiation Exposure
def f(x):
    import math
    return 10*math.e**(math.log(0.5)/5.27 * x)
    
def radiationExposure(start, stop, step):
    '''
    Computes and returns the amount of radiation exposed
    to between the start and stop times. Calls the 
    function f (defined for you in the grading script)
    to obtain the value of the function at any point.
 
    start: integer, the time at which exposure begins
    stop: integer, the time at which exposure ends
    step: float, the width of each rectangle. You can assume that
      the step size will always partition the space evenly.

    returns: float, the amount of radiation exposed to 
      between start and stop times.
    '''
    times = range(start, stop, step)
    result = 0
    for i in times:
        result += f(i)
    return result
    
def radiationExposure(start, stop, step):
    '''
    Computes and returns the amount of radiation exposed
    to between the start and stop times. Calls the 
    function f (defined for you in the grading script)
    to obtain the value of the function at any point.
 
    start: integer, the time at which exposure begins
    stop: integer, the time at which exposure ends
    step: float, the width of each rectangle. You can assume that
      the step size will always partition the space evenly.

    returns: float, the amount of radiation exposed to 
      between start and stop times.
    '''
    # create empty list to store time intervals based on start, stop, and step
    times = []
    
    # initialize time interval to start time
    time_int = start
    
    # initialize result to zero
    result = 0
    
    # populate times list with values starting with start time, at intervals of 
    # step
    while time_int < stop:
        times.append(time_int)
        time_int += step

    # calculate area using formula f to derive height, multiplied by width (i.e.
    # ,) step
    for i in times:
        result += f(i) * step
    return result
        
    
            

    
    
        














